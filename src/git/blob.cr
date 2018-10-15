require "./object"

module Git
  class Blob < Object
    @value : LibGit::Blob

    def size
      LibGit.blob_rawsize(@value)
    end

    def content(max_size : Int | Nil = nil)
      rawcontent = LibGit.blob_rawcontent(@value)
      size = LibGit.blob_rawsize(@value)
      if !max_size.nil? && max_size < size && max_size >= 0
        size = max_size
      end
      String.new(rawcontent.as(Pointer(UInt8)), size)
    end

    def text
      content
    end

    def is_binary
      LibGit.blob_is_binary(@value) == 1
    end

    def finalize
      LibGit.blob_free(@value)
    end

    def self.lookup(r : Repo, oid : Oid)
      nerr(LibGit.blob_lookup(out blob, r, oid.p))
      Blob.new(blob)
    end

    def self.lookup(r : Repo, oid : String)
      self.lookup(r, Oid.new(oid))
    end
  end
end
