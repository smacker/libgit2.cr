@[Link("git2")]
lib LibGit
  type Object = Void*

  enum OType
    ANY = -2
    BAD = -1
    # _EXT1 = 0
    COMMIT = 1
    TREE   = 2
    BLOB   = 3
    TAG    = 4
    # _EXT2 = 5
    OFS_DELTA = 6
    REF_DELTA = 7
  end

  fun object_lookup_prefix = git_object_lookup_prefix(object_out : Object*, repo : Repository, id : Oid*, len : LibC::SizeT, type : OType) : LibC::Int
  fun object_lookup = git_object_lookup(object : Object*, repo : Repository, id : Oid*, type : OType) : LibC::Int
  fun object_id = git_object_id(obj : Object) : Oid*
  fun object_short_id = git_object_short_id(out : Buf*, obj : Object) : LibC::Int
  fun object_type = git_object_type(obj : Object) : OType
  fun object_owner = git_object_owner(obj : Object) : Repository
  fun object_free = git_object_free(obj : Object)
end
