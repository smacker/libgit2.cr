@[Link("git2")]
lib LibGit
  type Remote = Void*

  struct RemoteHead
    local : LibC::Int
    oid : Oid
    loid : Oid
    name : LibC::Char*
    symref_target : LibC::Char*
  end

  fun remote_create = git_remote_create(out : Remote*, repo : Repository, name : LibC::Char*, url : LibC::Char*) : LibC::Int
  fun remote_create_with_fetchspec = git_remote_create_with_fetchspec(out : Remote*, repo : Repository, name : LibC::Char*, url : LibC::Char*, fetch : LibC::Char*) : LibC::Int
  fun remote_create_anonymous = git_remote_create_anonymous(out : Remote*, repo : Repository, url : LibC::Char*) : LibC::Int
  fun remote_lookup = git_remote_lookup(out : Remote*, repo : Repository, name : LibC::Char*) : LibC::Int
  fun remote_dup = git_remote_dup(dest : Remote*, source : Remote) : LibC::Int
  fun remote_owner = git_remote_owner(remote : Remote) : Repository
  fun remote_name = git_remote_name(remote : Remote) : LibC::Char*
  fun remote_url = git_remote_url(remote : Remote) : LibC::Char*
  fun remote_pushurl = git_remote_pushurl(remote : Remote) : LibC::Char*
  fun remote_set_url = git_remote_set_url(repo : Repository, remote : LibC::Char*, url : LibC::Char*) : LibC::Int
  fun remote_set_pushurl = git_remote_set_pushurl(repo : Repository, remote : LibC::Char*, url : LibC::Char*) : LibC::Int
  fun remote_add_fetch = git_remote_add_fetch(repo : Repository, remote : LibC::Char*, refspec : LibC::Char*) : LibC::Int
  fun remote_get_fetch_refspecs = git_remote_get_fetch_refspecs(array : Strarray*, remote : Remote) : LibC::Int
  fun remote_add_push = git_remote_add_push(repo : Repository, remote : LibC::Char*, refspec : LibC::Char*) : LibC::Int
  fun remote_get_push_refspecs = git_remote_get_push_refspecs(array : Strarray*, remote : Remote) : LibC::Int
  fun remote_refspec_count = git_remote_refspec_count(remote : Remote) : LibC::SizeT
  fun remote_ls = git_remote_ls(out : RemoteHead***, size : LibC::SizeT*, remote : Remote) : LibC::Int
  fun remote_connected = git_remote_connected(remote : Remote) : LibC::Int
  fun remote_stop = git_remote_stop(remote : Remote)
  fun remote_disconnect = git_remote_disconnect(remote : Remote)
  fun remote_free = git_remote_free(remote : Remote)
  fun remote_list = git_remote_list(out : Strarray*, repo : Repository) : LibC::Int
end
