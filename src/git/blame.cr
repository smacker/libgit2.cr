module Git
  class Blame < C_Pointer
    @value : LibGit::Blame

    def initialize(repo : Repo, path : String, newest_commit : Oid? = nil, oldest_commit : Oid? = nil, min_line : Int? = nil, max_line : Int? = nil)
      nerr(LibGit.blame_init_options(out opts, 1))
      if newest_commit.is_a?(Oid)
        opts.newest_commit = newest_commit
      end
      nerr(LibGit.blame_file(out @value, repo, path, pointerof(opts)))
    end

    def [](index : UInt32)
      fetch(index)
    end

    def fetch(index : UInt32)
      Hunk.new(LibGit.blame_get_hunk_byindex(@value, index))
    end

    def size
      LibGit.blame_get_hunk_count(@value)
    end

    def each
      size.times do |i|
        yield fetch(i)
      end
    end

    def finalize
      LibGit.blame_free(@value)
    end
  end

  class Blame::Hunk < C_Value
    @value : LibGit::BlameHunk*

    def lines_in_hunk
      @value.value.lines_in_hunk
    end

    def orig_commit_id
      Oid.new(@value.value.orig_commit_id)
    end

    def ==(other : Blame::Hunk)
      @value == other.to_unsafe
    end
  end
end
