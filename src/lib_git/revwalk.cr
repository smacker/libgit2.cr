@[Link("git2")]
lib LibGit
  type Revwalk = Void*

  enum Sort
    None        = 0
    Topological = 1
    Time        = 2
    Reverse     = 4
  end

  fun revwalk_new = git_revwalk_new(out : Revwalk*, repo : Repository) : LibC::Int
  fun revwalk_reset = git_revwalk_reset(walker : Revwalk)
  fun revwalk_push = git_revwalk_push(walk : Revwalk, id : Oid*) : LibC::Int
  fun revwalk_push_glob = git_revwalk_push_glob(walk : Revwalk, glob : LibC::Char*) : LibC::Int
  fun revwalk_push_head = git_revwalk_push_head(walk : Revwalk) : LibC::Int
  fun revwalk_hide = git_revwalk_hide(walk : Revwalk, commit_id : Oid*) : LibC::Int
  fun revwalk_hide_glob = git_revwalk_hide_glob(walk : Revwalk, glob : LibC::Char*) : LibC::Int
  fun revwalk_hide_head = git_revwalk_hide_head(walk : Revwalk) : LibC::Int
  fun revwalk_push_ref = git_revwalk_push_ref(walk : Revwalk, refname : LibC::Char*) : LibC::Int
  fun revwalk_hide_ref = git_revwalk_hide_ref(walk : Revwalk, refname : LibC::Char*) : LibC::Int
  fun revwalk_next = git_revwalk_next(out : Oid*, walk : Revwalk) : LibC::Int
  fun revwalk_sorting = git_revwalk_sorting(walk : Revwalk, sort_mode : LibC::UInt)
  fun revwalk_push_range = git_revwalk_push_range(walk : Revwalk, range : LibC::Char*) : LibC::Int
  fun revwalk_simplify_first_parent = git_revwalk_simplify_first_parent(walk : Revwalk)
  fun revwalk_free = git_revwalk_free(walk : Revwalk)
  fun revwalk_repository = git_revwalk_repository(walk : Revwalk) : Repository
  # fun revwalk_add_hide_cb = git_revwalk_add_hide_cb(walk : Revwalk, hide_cb : RevwalkHideCb, payload : Void*) : LibC::Int
end
