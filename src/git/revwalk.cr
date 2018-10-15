module Git
  alias Sort = LibGit::Sort

  class RevWalk < C_Pointer
    include Iterator(Commit)

    @value : LibGit::Revwalk

    def initialize(@repo : Repo)
      nerr(LibGit.revwalk_new(out walker, @repo))
      @value = walker
    end

    def push_head
      nerr(LibGit.revwalk_push_head(@value))
    end

    def push(oid : Oid)
      nerr(LibGit.revwalk_push(@value, oid.p))
    end

    def push(oid : String)
      push(Git::Oid.new(oid))
    end

    def sorting(sort_mode : Sort)
      LibGit.revwalk_sorting(@value, sort_mode)
    end

    def simplify_first_parent
      LibGit.revwalk_simplify_first_parent(@value)
    end

    def each
      while true
        r = LibGit.revwalk_next(out oid, @value)

        if r == LibGit::ErrorCode::Iterover.value
          break
        end

        nerr(r)

        nerr(LibGit.commit_lookup(out commit, @repo, pointerof(oid)))

        yield Commit.new(commit)
      end
    end

    def finalize
      LibGit.revwalk_free(@value)
    end
  end
end
