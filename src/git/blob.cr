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

    def binary?
      LibGit.blob_is_binary(@value) == 1
    end

    def loc
      data = LibGit.blob_rawcontent(@value).as(Pointer(UInt8))
      data_end = data + LibGit.blob_rawsize(@value)
      return 0 if data == data_end

      loc = 0

      eol = '\n'.ord
      reol = '\r'.ord
      while data < data_end - 1
        if data[0] == eol
          loc += 1
        elsif data[0] == reol
          data += 1 if data + 1 < data_end && data[1] == eol
          loc += 1
        end

        data += 1
      end
      loc += 1 if data[-1] != eol && data[-1] != reol

      loc
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

    def self.from_buffer(repo : Repo, data : String)
      nerr(LibGit.blob_create_frombuffer(out oid, repo, data, data.size))
      Oid.new(oid)
    end
  end
end
