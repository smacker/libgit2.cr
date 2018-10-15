module Git
  alias RefType = LibGit::RefT

  class Reference < C_Pointer
    @value : LibGit::Reference

    def name
      String.new(LibGit.reference_name(@value))
    end

    def canonical_name
      name
    end

    def type
      LibGit.reference_type(@value)
    end

    def target
      if self.type == RefType::Oid
        nerr(LibGit.object_lookup(out obj, LibGit.reference_owner(@value), LibGit.reference_target(@value), LibGit::OType::ANY))
        Object.new(obj)
      else
        nerr(LibGit.reference_lookup(out ref, LibGit.reference_owner(@value), LibGit.reference_symbolic_target(@value)))
        Reference.new(ref)
      end
    end

    def target_id
      if self.type == RefType::Oid
        Oid.new(LibGit.reference_target(@value).value)
      else
        String.new(LibGit.reference_symbolic_target(@value))
      end
    end

    def peel
      err = LibGit.reference_peel(out obj, @value, OType::ANY)
      if err == LibGit::ErrorCode::Enotfound.value
        nil
      else
        nerr(err)

        if LibGit.reference_type(@value) == RefType::Oid && LibGit.oid_cmp(LibGit.object_id(obj), LibGit.reference_target(@value)) == 0
          LibGit.object_free(obj)
          nil
        else
          LibGit.object_free(obj)
          Oid.new(LibGit.object_id(obj).value)
        end
      end
    end

    def resolve
      nerr(LibGit.reference_resolve(out ref, @value))
      Reference.new(ref)
    end

    def branch?
      LibGit.reference_is_branch(@value) == 1
    end

    def remote?
      LibGit.reference_is_remote(@value) == 1
    end

    def tag?
      LibGit.reference_is_tag(@value) == 1
    end

    def finalize
      LibGit.reference_free(@value)
    end

    def self.valid_name?(name)
      LibGit.reference_is_valid_name(name) == 1
    end
  end

  class ReferenceCollection < NoError
    include Enumerable(Reference)
    include Iterable(Reference)

    def initialize(@repo : Repo)
    end

    def [](name)
      nerr(LibGit.reference_lookup(out ref, @repo, name))
      Reference.new(ref)
    end

    def []?(name)
      err = LibGit.reference_lookup(out ref, @repo, name)
      if err == LibGit::ErrorCode::Enotfound.value
        nil
      else
        nerr(err)
        Reference.new(ref)
      end
    end

    def each
      RefIterator.new(@repo)
    end

    def each : Nil
      RefIterator.new(@repo).each do |ref|
        yield ref
      end
    end

    def each(glob : String)
      RefIterator.new(@repo, glob)
    end

    def each(glob : String) : Nil
      RefIterator.new(@repo, glob).each do |ref|
        yield ref
      end
    end

    def exists?(name)
      err = LibGit.reference_lookup(out ref, @repo, name)
      if err == LibGit::ErrorCode::Enotfound.value
        false
      else
        nerr(err)
        true
      end
    end

    private class RefIterator < NoError
      include Iterator(Reference)

      def initialize(repo : Repo)
        nerr(LibGit.reference_iterator_new(out @iter, repo))
      end

      def initialize(repo : Repo, glob : String)
        nerr(LibGit.reference_iterator_glob_new(out @iter, repo, glob))
      end

      def next
        r = LibGit.reference_next(out ref, @iter)

        if r == LibGit::ErrorCode::Iterover.value
          stop
        else
          nerr(r)

          Reference.new(ref)
        end
      end

      def finalize
        LibGit.reference_iterator_free(@iter)
      end
    end
  end
end
