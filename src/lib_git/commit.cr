@[Link("git2")]
lib LibGit
  type Commit = Void*

  fun commit_lookup = git_commit_lookup(commit : Commit*, repo : Repository, id : Oid*) : LibC::Int
  fun commit_lookup_prefix = git_commit_lookup_prefix(commit : Commit*, repo : Repository, id : Oid*, len : LibC::SizeT) : LibC::Int
  fun commit_free = git_commit_free(commit : Commit)
  fun commit_id = git_commit_id(commit : Commit) : Oid*
  fun commit_owner = git_commit_owner(commit : Commit) : Repository
  fun commit_message_encoding = git_commit_message_encoding(commit : Commit) : LibC::Char*
  fun commit_message = git_commit_message(commit : Commit) : LibC::Char*
  fun commit_message_raw = git_commit_message_raw(commit : Commit) : LibC::Char*
  fun commit_summary = git_commit_summary(commit : Commit) : LibC::Char*
  fun commit_body = git_commit_body(commit : Commit) : LibC::Char*
  fun commit_time = git_commit_time(commit : Commit) : TimeT
  fun commit_time_offset = git_commit_time_offset(commit : Commit) : LibC::Int
  fun commit_committer = git_commit_committer(commit : Commit) : Signature*
  fun commit_author = git_commit_author(commit : Commit) : Signature*
  fun commit_raw_header = git_commit_raw_header(commit : Commit) : LibC::Char*
  fun commit_tree = git_commit_tree(tree_out : Tree*, commit : Commit) : LibC::Int
  fun commit_tree_id = git_commit_tree_id(commit : Commit) : Oid*
  fun commit_parentcount = git_commit_parentcount(commit : Commit) : LibC::UInt
  fun commit_parent = git_commit_parent(out : Commit*, commit : Commit, n : LibC::UInt) : LibC::Int
  fun commit_parent_id = git_commit_parent_id(commit : Commit, n : LibC::UInt) : Oid*
  fun commit_nth_gen_ancestor = git_commit_nth_gen_ancestor(ancestor : Commit*, commit : Commit, n : LibC::UInt) : LibC::Int
  fun commit_header_field = git_commit_header_field(out : Buf*, commit : Commit, field : LibC::Char*) : LibC::Int
  fun commit_extract_signature = git_commit_extract_signature(signature : Buf*, signed_data : Buf*, repo : Repository, commit_id : Oid*, field : LibC::Char*) : LibC::Int
  fun commit_create = git_commit_create(id : Oid*, repo : Repository, update_ref : LibC::Char*, author : Signature*, committer : Signature*, message_encoding : LibC::Char*, message : LibC::Char*, tree : Tree, parent_count : LibC::SizeT, parents : Commit*) : LibC::Int
  fun commit_create_v = git_commit_create_v(id : Oid*, repo : Repository, update_ref : LibC::Char*, author : Signature*, committer : Signature*, message_encoding : LibC::Char*, message : LibC::Char*, tree : Tree, parent_count : LibC::SizeT, ...) : LibC::Int
  fun commit_amend = git_commit_amend(id : Oid*, commit_to_amend : Commit, update_ref : LibC::Char*, author : Signature*, committer : Signature*, message_encoding : LibC::Char*, message : LibC::Char*, tree : Tree) : LibC::Int
  fun commit_create_buffer = git_commit_create_buffer(out : Buf*, repo : Repository, author : Signature*, committer : Signature*, message_encoding : LibC::Char*, message : LibC::Char*, tree : Tree, parent_count : LibC::SizeT, parents : Commit*) : LibC::Int
  fun commit_create_with_signature = git_commit_create_with_signature(out : Oid*, repo : Repository, commit_content : LibC::Char*, signature : LibC::Char*, signature_field : LibC::Char*) : LibC::Int
  fun commit_dup = git_commit_dup(out : Commit*, source : Commit) : LibC::Int
end
