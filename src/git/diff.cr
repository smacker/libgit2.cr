module Git
  class Diff < C_Pointer
    @value : LibGit::Diff

    def self.make_opts
      opts = uninitialized LibGit::DiffOptions
      LibGit.diff_init_options(pointerof(opts), LibGit::DIFF_OPTIONS_VERSION)
      opts.context_lines = 1
      opts.interhunk_lines = 1

      opts
    end

    def self.tree_to_tree(a : Tree, b : Tree)
      opts = make_opts()
      LibGit.diff_tree_to_tree(out diff, LibGit.tree_owner(a), a, b, pointerof(opts))
      new(diff)
    end

    def self.tree_to_tree(a : Tree, b : Nil)
      opts = make_opts()
      LibGit.diff_tree_to_tree(out diff, LibGit.tree_owner(a), a, nil, pointerof(opts))
      new(diff)
    end

    def find_similar!
      opts = uninitialized LibGit::DiffFindOptions
      LibGit.diff_find_init_options(pointerof(opts), LibGit::DIFF_FIND_OPTIONS_VERSION)
      # FIXME
      opts.flags = LibGit::DiffFindRenames
      LibGit.diff_find_similar(@value, pointerof(opts))
    end

    def size
      LibGit.diff_num_deltas(@value)
    end

    def stat
      raise NotImplementedError
    end

    def each_patch
      deltas = LibGit.diff_num_deltas(@value)
      i = 0
      while i < deltas
        nerr(LibGit.patch_from_diff(out patch, @value, i))
        yield Patch.new(patch)
        i += 1
      end
    end

    def each_delta
      deltas = LibGit.diff_num_deltas(@value)
      i = 0
      while i < deltas
        yield DiffDelta.new(LibGit.diff_get_delta(@value, i))
        i += 1
      end
    end

    def each_line
      raise NotImplementedError
    end

    # fixme it's alias to each_patch
    def each(&block)
      deltas = LibGit.diff_num_deltas(@value)
      i = 0
      while i < deltas
        nerr(LibGit.patch_from_diff(out patch, @value, i))
        yield Patch.new(patch)
        i += 1
      end
    end

    def patches
      # each_patch.to_a
      ary = [] of Patch
      each_patch { |e| ary << e }
      ary
    end

    def deltas
      # each_delta.to_a
      ary = [] of DiffDelta
      each_delta { |e| ary << e }
      ary
    end

    # def foreach(file_cb : DiffDelta -> Int32, hunk_cb : DiffDelta, DiffHunk -> Int32)
    #   payload_cb = {file_cb, hunk_cb}
    #   boxed_data = Box.box(payload_cb)

    #   file_cb_c = ->(delta : C::DiffDelta*, progress : LibC::Float, payload : Void*) {
    #     payload_as_cb = Box(typeof(payload_cb)).unbox(payload)[0]
    #     payload_as_cb.call(DiffDelta.new(delta))
    #   }

    #   hunk_cb_c = ->(delta : C::DiffDelta*, hunk : C::DiffHunk*, payload : Void*) {
    #     payload_as_cb = Box(typeof(payload_cb)).unbox(payload)[1]
    #     payload_as_cb.call(DiffDelta.new(delta), DiffHunk.new(hunk))
    #   }

    #   # line_cb_c = ->(delta : C::DiffDelta*, hunk : C::DiffHunk*, line : C::DiffLine*, payload : Void*) {
    #   #   payload_as_cb = Box(typeof(payload_cb)).unbox(payload)[1]
    #   #   payload_as_cb.call(DiffDelta.new(delta), DiffLine.new(line))
    #   # }

    #   # LibGit.diff_foreach(@value, file_cb_c, nil, hunk_cb_c, line_cb_c, boxed_data)
    #   LibGit.diff_foreach(@value, file_cb_c, nil, hunk_cb_c, nil, boxed_data)
    # end

    def finalize
      LibGit.diff_free(@value)
    end
  end

  class DiffFile < C_Value
    @value : LibGit::DiffFile

    def id
      Oid.new(@value.id)
    end

    def path
      String.new(@value.path)
    end

    def size
      @value.size
    end
  end

  alias DeltaType = LibGit::DeltaT

  class DiffDelta < C_Value
    @value : LibGit::DiffDelta*

    def status
      @value.value.status
    end

    def old_file
      DiffFile.new(@value.value.old_file)
    end

    def new_file
      DiffFile.new(@value.value.new_file)
    end

    def added?
      status == DeltaType::Added
    end

    def deleted?
      status == DeltaType::Deleted
    end

    def modified?
      status == DeltaType::Modified
    end
  end

  class DiffHunk < C_Value
    @value : LibGit::DiffHunk*

    def initialize(@value, @patch : LibGit::Patch, @hunk_idx : UInt64, @lines_count : UInt64)
    end

    def old_start
      @value.value.old_start
    end

    def old_lines
      @value.value.old_lines
    end

    def new_start
      @value.value.new_start
    end

    def new_lines
      @value.value.new_lines
    end

    def lines
      @lines_count.times do |l|
        nerr(LibGit.patch_get_line_in_hunk(out line, @patch, @hunk_idx, l))
        yield DiffLine.new(line)
      end
    end
  end

  class DiffLine < C_Value
    @value : LibGit::DiffLine*
    enum Type
      Added
      Modified
      Deleted
    end

    def type
      v = @value.value
      if v.old_lineno == -1 && v.new_lineno == -1
        raise "how is it possible?"
      end
      if v.old_lineno == -1
        Type::Added
      elsif v.new_lineno == -1
        Type::Deleted
      else
        Type::Modified
      end
    end

    def origin
      @value.value.origin
    end

    def context?
      origin == LibGit::DIFF_LINE_CONTEXT.ord
    end

    def addition?
      origin == LibGit::DIFF_LINE_ADDITION.ord
    end

    def deletion?
      origin == LibGit::DIFF_LINE_DELETION.ord
    end

    def old_lineno
      @value.value.old_lineno
    end

    def new_lineno
      @value.value.new_lineno
    end

    def content
      String.new(@value.value.content)
    end

    def content_offset
      @value.value.content_offset
    end

    # FIXME remove
    def v
      @value.value
    end
  end

  class Patch < C_Pointer
    @value : LibGit::Patch

    def hunks
      num = LibGit.patch_num_hunks(@value)
      num.times do |i|
        nerr(LibGit.patch_get_hunk(out hunk, out lines, @value, i))
        yield DiffHunk.new(hunk, @value, i, lines)
      end
    end
    
    def delta
      DiffDelta.new(LibGit.patch_get_delta(@value))
    end

    def to_s
      buf = LibGit::Buf.new
      nerr(LibGit.patch_to_buf(pointerof(buf), @value))
      String.new(buf.ptr)
    end

    def finalize
      LibGit.patch_free(@value)
    end
  end
end

# file_cb_c = ->(delta : C::DiffDelta*, progress : LibC::Float, payload : Void*) {
#   0
# }
# binary_cb_c = ->(delta : C::DiffDelta*, binary : C::DiffBinary*, payload : Void*) {
#   0
# }
# hunk_cb_c = ->(delta : C::DiffDelta*, hunk : C::DiffHunk*, payload : Void*) {
#   0
# }
