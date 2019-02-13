module Git
  class Remote < C_Pointer
    @value : LibGit::Remote

    def name
      String.new(LibGit.remote_name(@value))
    end

    def url
      v = LibGit.remote_url(@value)
      if v.null?
        nil
      else
        String.new(v)
      end
    end

    def push_url
      v = LibGit.remote_pushurl(@value)
      if v.null?
        nil
      else
        String.new(v)
      end
    end

    def finalize
      LibGit.remote_free(@value)
    end
  end

  class RemoteCollection < NoError
    include Enumerable(Remote)
    include Iterable(Remote)

    def initialize(@repo : Repo)
    end

    def [](name)
      nerr(LibGit.remote_lookup(out remote, @repo, name))
      Remote.new(remote)
    end

    def []?(name)
      err = LibGit.remote_lookup(out remote, @repo, name)
      if err == LibGit::ErrorCode::Enotfound.value
        nil
      else
        nerr(err)
        Remote.new(remote)
      end
    end

    def each
      nerr(LibGit.remote_list(out remotes, @repo))

      i = 0
      while i < remotes.count
        err = LibGit.remote_lookup(out remote, @repo, remotes.strings[i])
        if err == 0
          yield Remote.new(remote)
        end
        i += 1
      end
    end
  end
end
