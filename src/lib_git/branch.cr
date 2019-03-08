@[Link("git2")]
lib LibGit
  type BranchIterator = Void*

  enum BranchT
    Local  = 1
    Remote = 2
    All    = 3
  end

  fun branch_iterator_new = git_branch_iterator_new(out : BranchIterator*, repo : Repository, list_flags : BranchT) : LibC::Int
  fun branch_create = git_branch_create(out : Reference*, repo : Repository, branch_name : LibC::Char*, target : Commit, force : LibC::Int) : LibC::Int
  fun branch_next = git_branch_next(out : Reference*, out_type : BranchT*, iter : BranchIterator) : LibC::Int
  fun branch_iterator_free = git_branch_iterator_free(iter : BranchIterator)
  fun branch_move = git_branch_move(out : Reference*, branch : Reference, new_branch_name : LibC::Char*, force : LibC::Int) : LibC::Int
  fun branch_lookup = git_branch_lookup(out : Reference*, repo : Repository, branch_name : LibC::Char*, branch_type : BranchT) : LibC::Int
  fun branch_name = git_branch_name(out : LibC::Char**, ref : Reference) : LibC::Int
  fun branch_upstream = git_branch_upstream(out : Reference*, branch : Reference) : LibC::Int
  fun branch_set_upstream = git_branch_set_upstream(branch : Reference, upstream_name : LibC::Char*) : LibC::Int
  fun branch_upstream_name = git_branch_upstream_name(out : Buf*, repo : Repository, refname : LibC::Char*) : LibC::Int
  fun branch_is_head = git_branch_is_head(branch : Reference) : LibC::Int
  fun branch_remote_name = git_branch_remote_name(out : Buf*, repo : Repository, canonical_branch_name : LibC::Char*) : LibC::Int
  fun branch_upstream_remote = git_branch_upstream_remote(buf : Buf*, repo : Repository, refname : LibC::Char*) : LibC::Int
end
