module Git
  class Error < Exception
    def initialize(@class : Int32, @message)
    end
  end

  private abstract class NoError
    private def self.nerr(code : Int, msg = "git error")
      # FIXME possible to figure out git error message
      if code != 0
        e = LibGit.err_last
        raise Error.new(e.klass, msg)
      end
    end

    private def nerr(code : Int, msg = "git error")
      # FIXME possible to figure out git error message
      if code != 0
        e = LibGit.err_last
        raise Error.new(e.klass, msg)
      end
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
