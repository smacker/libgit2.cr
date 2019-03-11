module Git
  class ODB < C_Pointer
    @value : LibGit::Odb

    def finalize
      LibGit.odb_free(@value)
    end
  end

  class OdbObject < C_Pointer
    @value : LibGit::OdbObject

    def data
      String.new(LibGit.odb_object_data(@value).as(Pointer(UInt8)))
    end

    def size
      LibGit.odb_object_size(@value)
    end

    def type
      LibGit.git_odb_object_type(@value)
    end

    def oid
      Oid.new(LibGit.odb_object_id(@value).value)
    end

    def finalize
      LibGit.odb_object_free(@value)
    end
  end
end
