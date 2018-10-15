module Git
  alias OType = LibGit::OType

  abstract class Object < C_Pointer
    def oid
      Oid.new(LibGit.object_id(@value.as(LibGit::Object)).value)
    end

    def type
      LibGit.object_type(@value.as(LibGit::Object))
    end

    def self.lookup(repo : Repo, sha : String)
      if sha.size > LibGit::OID_HEXSZ
        raise "The given sha is too long"
      end

      oid_length = sha.size

      nerr(LibGit.oid_fromstrn(out oid, sha, oid_length))

      if oid_length < LibGit::OID_HEXSZ
        nerr(LibGit.object_lookup_prefix(out object, repo, pointerof(oid), oid_length, OType::ANY))
        new(object)
      else
        nerr(LibGit.object_lookup(out object_, repo, pointerof(oid), OType::ANY))
        new(object_)
      end
    end

    def self.new(obj : LibGit::Object)
      case LibGit.object_type(obj)
      when LibGit::OType::COMMIT
        Commit.new(obj.as(LibGit::Commit))
      when LibGit::OType::TAG
        Tag.new(obj.as(LibGit::Tag))
      else
        raise "Invalid object type"
      end
    end
  end
end
