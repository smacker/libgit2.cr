require "./object"

module Git
  class Tag < Object
    @value : LibGit::Tag

    def name
      String.new(LibGit.tag_name(@value))
    end

    def message
      String.new(LibGit.tag_message(@value))
    end

    # def target
    #   nerr(LibGit.tag_target(out target, @value))
    #   Object.new(target)
    # end

    def target_type
      LibGit.tag_target_type(@value)
    end

    def target_oid
      Oid.new(LibGit.tag_target_id(@value).value)
    end

    def tagger
      Signature.new(LibGit.tag_tagger(@value).value)
    end

    def finalize
      LibGit.tag_free(@value)
    end
  end

  class TagCollection < NoError
    include Enumerable(Tag)

    @keys : Array(String)

    def initialize(@repo : Repo)
      nerr(LibGit.tag_list(out arr, @repo))
      @keys = arr.count.times.map { |i| String.new(arr.strings[i]) }.to_a
      LibGit.strarray_free(pointerof(arr))
    end

    def initialize(@repo : Repo, glob : String)
      nerr(LibGit.tag_list_match(out arr, glob, @repo))
      @keys = arr.count.times.map { |i| String.new(arr.strings[i]) }.to_a
      LibGit.strarray_free(pointerof(arr))
    end

    def [](name)
      fetch(name)
    end

    def fetch(name)
      err = LibGit.reference_lookup(out tag, @repo, name)
      if err == LibGit::ErrorCode::Enotfound.value || err == LibGit::ErrorCode::Einvalidspec.value
        canonical_ref = "refs/tags/#{name}"
        nerr(LibGit.reference_lookup(out ref, @repo, canonical_ref))
        Tag.new(ref.as(LibGit::Tag))
      else
        nerr(err)
        Tag.new(tag.as(LibGit::Tag))
      end
    end

    def each
      @keys.each do |name|
        yield fetch(name)
      end
    end

    def each_name
      raise "not implemented"
    end

    # private class KeysIterator < NoError
    #   include Iterator(String)

    #   @i = 0

    #   def next
    #     if @i >= @arr.count
    #       stop
    #     else
    #       v = @arr.strings[@i]
    #       @i += 1
    #       v
    #     end
    #   end

    #   def rewind
    #     @i = 0
    #   end
    # end
  end
end
