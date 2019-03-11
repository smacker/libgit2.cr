@[Link("git2")]
lib LibGit
  enum FilemodeT
    FilemodeUnreadable     =     0
    FilemodeTree           = 16384
    FilemodeBlob           = 33188
    FilemodeBlobExecutable = 33261
    FilemodeLink           = 40960
    FilemodeCommit         = 57344
  end

  enum TreewalkMode
    TreewalkPre  = 0
    TreewalkPost = 1
  end

  type Tree = Void*
  type TreeEntry = Void*
  type TreeBuilder = Void*

  alias TreewalkCb = (LibC::Char*, TreeEntry, Void* -> LibC::Int)

  fun tree_lookup = git_tree_lookup(out : Tree*, repo : Repository, id : Oid*) : LibC::Int
  fun tree_walk = git_tree_walk(tree : Tree, mode : TreewalkMode, callback : TreewalkCb, payload : Void*) : LibC::Int
  fun tree_free = git_tree_free(tree : Tree)
  fun tree_id = git_tree_id(tree : Tree) : Oid*
  fun tree_owner = git_tree_owner(tree : Tree) : Repository

  fun tree_entrycount = git_tree_entrycount(tree : Tree) : LibC::SizeT
  fun tree_entry_byindex = git_tree_entry_byindex(tree : Tree, idx : LibC::SizeT) : TreeEntry
  fun tree_entry_byname = git_tree_entry_byname(tree : Tree, filename : LibC::Char*) : TreeEntry
  fun tree_entry_byindex = git_tree_entry_byindex(tree : Tree, idx : LibC::SizeT) : TreeEntry
  fun tree_entry_byid = git_tree_entry_byid(tree : Tree, id : Oid*) : TreeEntry
  fun tree_entry_bypath = git_tree_entry_bypath(out : TreeEntry*, root : Tree, path : LibC::Char*) : LibC::Int
  fun tree_entry_dup = git_tree_entry_dup(dest : TreeEntry*, source : TreeEntry) : LibC::Int
  fun tree_entry_free = git_tree_entry_free(entry : TreeEntry)
  fun tree_entry_name = git_tree_entry_name(entry : TreeEntry) : LibC::Char*
  fun tree_entry_id = git_tree_entry_id(entry : TreeEntry) : Oid*
  fun tree_entry_type = git_tree_entry_type(entry : TreeEntry) : OType
  fun tree_entry_filemode = git_tree_entry_filemode(entry : TreeEntry) : FilemodeT
  fun tree_entry_to_object = git_tree_entry_to_object(object_out : Object*, repo : Repository, entry : TreeEntry) : LibC::Int

  fun treebuilder_new = git_treebuilder_new(out : TreeBuilder*, repo : Repository, source : Tree) : LibC::Int
  fun treebuilder_clear = git_treebuilder_clear(bld : TreeBuilder)
  fun treebuilder_entrycount = git_treebuilder_entrycount(bld : TreeBuilder) : LibC::UInt
  fun treebuilder_free = git_treebuilder_free(bld : TreeBuilder)
  fun treebuilder_get = git_treebuilder_get(bld : TreeBuilder, filename : LibC::Char*) : TreeEntry
  fun treebuilder_insert = git_treebuilder_insert(out : TreeEntry*, bld : TreeBuilder, filename : LibC::Char*, id : Oid*, filemode : FilemodeT) : LibC::Int
  fun treebuilder_remove = git_treebuilder_remove(bld : TreeBuilder, filename : LibC::Char*) : LibC::Int
  fun treebuilder_write = git_treebuilder_write(id : Oid*, bld : TreeBuilder) : LibC::Int
end
