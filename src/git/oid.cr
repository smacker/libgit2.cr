module Git
  class Oid < C_Object
    @value : LibGit::Oid

    def initialize(@value : LibGit::Oid)
    end

    def initialize(sha : String)
      if sha.size == 40
        nerr(LibGit.oid_fromstr(out @value, sha))
      else
        nerr(LibGit.oid_fromstrn(out @value, sha, sha.size))
      end
    end

    def <=>(other : Oid)
      LibGit.oid_cmp(self.p, other.p)
    end

    def ==(other : Oid)
      LibGit.oid_cmp(self.p, other.p) == 0
    end

    def to_s(io)
      p = LibGit.oid_tostr_s(self.p)
      io << String.new(p)
    end
  end
end
