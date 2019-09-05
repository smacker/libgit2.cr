module Git
  alias RefType = LibGit::RefT

  class RefLogEntry
    getter id_old, id_new, committer, message

    def initialize(@id_old : Oid, @id_new : Oid, @committer : Signature, @message : String | Nil)
    end
  end

  class RefLog < Array(RefLogEntry)
    @reflog : LibGit::Reflog

    def initialize(@reflog : LibGit::Reflog)
      super()

      ref_count = LibGit.reflog_entrycount(@reflog)

      i = 0
      while i < ref_count
        entry = LibGit.reflog_entry_byindex(reflog, ref_count - i - 1)
        self.push(reflog_entry_new(entry))
        i += 1
      end
    end

    private def reflog_entry_new(entry)
      m = LibGit.reflog_entry_message(entry)

      RefLogEntry.new(Oid.new(LibGit.reflog_entry_id_old(entry).value),
        Oid.new(LibGit.reflog_entry_id_new(entry).value),
        Signature.new(LibGit.reflog_entry_committer(entry)),
        m.null? ? nil : String.new(m))
    end

    def finalize
      LibGit.reflog_free(@reflog)
    end
  end

  class Reference < C_Pointer
    @value : LibGit::Reference

    def name
      canonical_name
    end

    def canonical_name
      String.new(LibGit.reference_name(@value))
    end

    def log
      nerr(LibGit.reflog_read(out reflog, LibGit.reference_owner(@value), LibGit.reference_name(@value)))
      RefLog.new(reflog)
    end

    def log?
      LibGit.reference_has_log(LibGit.reference_owner(@value), LibGit.reference_name(@value)) == 1
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
      if err == LibGit::ErrorCode::NotFound.value
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
    include Iterable(Reference)

    def initialize(@repo : Repo)
    end

    def [](name)
      nerr(LibGit.reference_lookup(out ref, @repo, name))
      Reference.new(ref)
    end

    def []?(name)
      err = LibGit.reference_lookup(out ref, @repo, name)
      if err == LibGit::ErrorCode::NotFound.value
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
      if err == LibGit::ErrorCode::NotFound.value
        false
      else
        nerr(err)
        true
      end
    end

    def create(name : String, oid : Oid, force = false)
      log_message = nil
      nerr(LibGit.reference_create(out ref, @repo, name, oid.p, force, log_message))
      Reference.new(ref)
    end

    def create(name : String, target : String, force = false)
      if LibGit.oid_fromstr(out oid, target) == 0
        create(name, Oid.new(oid), force)
      else
        log_message = nil
        nerr(LibGit.reference_symbolic_create(out ref, @repo, name, target, force, log_message))
        Reference.new(ref)
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
