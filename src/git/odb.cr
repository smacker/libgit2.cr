module Git
  class ODB < C_Pointer
    @value : LibGit::Odb

    def finalize
      LibGit.odb_free(@value)
    end
  end
end
