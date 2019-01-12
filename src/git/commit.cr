require "./object"

module Git
  class Signature < C_Value
    @value : LibGit::Signature

    def name
      String.new(@value.name)
    end

    def email
      String.new(@value.email)
    end

    def epoch_time
      @value.when.time
    end

    def time
      Time.unix(epoch_time)
    end
  end

  class Commit < Object
    @value : LibGit::Commit

    def sha
      oid = LibGit.commit_id(@value)
      p = LibGit.oid_tostr_s(oid)
      String.new(p)
    end

    def epoch_time
      LibGit.commit_time(@value)
    end

    def time
      Time.unix(epoch_time)
    end

    def author
      Signature.new(LibGit.commit_author(@value).value)
    end

    def committer
      Signature.new(LibGit.commit_committer(@value).value)
    end

    def message
      String.new(LibGit.commit_message(@value))
    end

    def parents
      parent_count.times.map { |i| parent(i) }.to_a
    end

    def parent_count
      LibGit.commit_parentcount(@value)
    end

    def tree
      nerr(LibGit.commit_tree(out t, @value))
      Tree.new(t)
    end

    def parent
      parent(0)
    end

    def parent(n : Int)
      nerr(LibGit.commit_parent(out parent, @value, n))
      Commit.new(parent)
    end

    def to_s(io)
      io << sha
    end

    def finalize
      LibGit.commit_free(@value)
    end

    def self.lookup(repo : Repo, oid : Oid)
      nerr(LibGit.commit_lookup(out commit, repo, oid.p))
      Commit.new(commit)
    end

    def self.lookup(repo : Repo, sha : String)
      if sha.size == 40
        self.lookup(repo, Git::Oid.new(sha))
      else
        nerr(LibGit.commit_lookup_prefix(out commit, repo, Git::Oid.new(sha).p, sha.size))
        Commit.new(commit)
      end
    end
  end
end
