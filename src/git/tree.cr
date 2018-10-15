require "./object"

module Git
  alias TreewalkMode = LibGit::TreewalkMode

  class TreeEntry < C_Pointer
    @value : LibGit::TreeEntry

    def name
      String.new(LibGit.tree_entry_name(@value))
    end

    def oid
      Oid.new(LibGit.tree_entry_id(@value).value)
    end

    def filemode
      LibGit.tree_entry_filemode(@value)
    end

    def type
      LibGit.tree_entry_type(@value)
    end

    def finalize
      # LibGit.tree_entry_free(@value)
    end
  end

  class Tree < Object
    include Enumerable(TreeEntry)

    @value : LibGit::Tree

    def size
      LibGit.tree_entrycount(@value)
    end

    def size_recursive
      count = 0_i64

      box_count = pointerof(count)
      treecount_cb = ->(root : LibC::Char*, entry : LibGit::TreeEntry, payload : Void*) {
        if LibGit.tree_entry_type(entry) != OType::TREE
          payload.as(Pointer(Int64)).value += 1
        end
        return 0
      }
      LibGit.tree_walk(@value, TreewalkMode::TreewalkPre, treecount_cb, box_count)

      count
    end

    def path(path : String)
      raise "not implemented"
    end

    def [](idx : Int)
      get_entry(idx)
    end

    def get_entry(idx : Int)
      TreeEntry.new(LibGit.tree_entry_byindex(@value, idx))
    end

    def get_entry(id : Oid)
      e = LibGit.tree_entry_byid(@value, id.p)
      if e.null?
        raise Exception.new("no entry with such id")
      else
        TreeEntry.new(e)
      end
    end

    def get_entry?(id : Oid)
      e = LibGit.tree_entry_byid(@value, id.p)
      if e.null?
        nil
      else
        TreeEntry.new(e)
      end
    end

    def each
      count = LibGit.tree_entrycount(@value)
      i = 0
      while i < count
        yield TreeEntry.new(LibGit.tree_entry_byindex(@value, i))
        i += 1
      end
    end

    def each_tree
      each { |e| yield e if e.type == OType::TREE }
    end

    def each_blob
      each { |e| yield e if e.type == OType::BLOB }
    end

    @@box : Pointer(Void) | Nil

    def walk(mode : TreewalkMode, &callback : String, TreeEntry -> Bool | Nil)
      boxed_data = Box.box(callback)
      # We must save this in Crystal-land so the GC doesn't collect it (*)
      @@box = boxed_data

      cb = ->(root : LibC::Char*, entry : LibGit::TreeEntry, payload : Void*) {
        inner_cb = Box(typeof(callback)).unbox(payload)
        result = inner_cb.call(String.new(root), TreeEntry.new(entry))
        if result.nil? || !result
          0
        else
          1
        end
      }

      nerr(LibGit.tree_walk(@value, mode, cb, boxed_data))
    end

    def walk_trees(mode : TreewalkMode = TreewalkMode::TreewalkPre, &callback : String, TreeEntry -> Bool | Nil)
      walk(mode) do |root, e|
        callback.call(root, e) if e.type == OType::TREE
      end
    end

    def walk_blobs(mode : TreewalkMode = TreewalkMode::TreewalkPre, &callback : String, TreeEntry -> Bool | Nil)
      walk(mode) do |root, e|
        callback.call(root, e) if e.type == OType::BLOB
      end
    end

    def diff(other : Tree | Nil)
      Diff.tree_to_tree(self, other)
    end

    def finalize
      LibGit.tree_free(@value)
    end
  end
end
