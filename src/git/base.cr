module Git
  enum ErrorClass
    NONE       = 0
    NOMEMORY
    OS
    INVALID
    REFERENCE
    ZLIB
    REPOSITORY
    CONFIG
    REGEX
    ODB
    INDEX
    OBJECT
    NET
    TAG
    TREE
    INDEXER
    SSL
    SUBMODULE
    THREAD
    STASH
    CHECKOUT
    FETCHHEAD
    MERGE
    SSH
    FILTER
    REVERT
    CALLBACK
    CHERRYPICK
    DESCRIBE
    REBASE
    FILESYSTEM
    PATCH
    WORKTREE
    SHA1
  end

  class Error < Exception
    def initialize(code : Int, klass : Int32, message)
      @code = LibGit::ErrorCode.from_value(code)
      @message = @code.to_s + ": " + message
    end
  end

  class NotFoundError < Error
    def initialize(klass : Int32, message)
      @code = LibGit::ErrorCode::NotFound
      @message = @code.to_s + ": " + message
    end
  end

  private abstract class NoError
    private def self.nerr(code : Int, msg = "git error")
      if code == 0
        return
      end

      # FIXME possible to figure out why err_last returns garbage
      e = LibGit.err_last
      raise NotFoundError.new(e.klass, msg) if code == LibGit::ErrorCode::NotFound
      raise Error.new(code, e.klass, msg)
    end

    private def nerr(code : Int, msg = "git error")
      if code == 0
        return
      end

      # FIXME possible to figure out why err_last returns garbage
      e = LibGit.err_last
      raise NotFoundError.new(e.klass, msg) if code == LibGit::ErrorCode::NotFound
      raise Error.new(code, e.klass, msg)
    end
  end

  private abstract class C_Value < NoError
    protected def initialize(@value)
    end

    def ==(other : self)
      @value == other.to_unsafe
    end

    def to_unsafe
      @value
    end
  end

  private class C_Object < C_Value
    def p
      pointerof(@value)
    end
  end

  private abstract class C_Pointer < C_Value
    abstract def finalize
  end
end
