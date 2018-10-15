@[Link("git2")]
lib LibGit
  # Size (in bytes) of a raw/binary oid
  OID_RAWSZ = 20
  # Size (in bytes) of a hex formatted oid
  OID_HEXSZ = (OID_RAWSZ * 2)
  # Minimum length (in number of hex characters, i.e. packets of 4 bits) of an oid prefix
  OID_MINPREFIXLEN = 4

  struct Oid
    id : UInt8[20]
  end

  fun oid_fromstr = git_oid_fromstr(out : Oid*, str : LibC::Char*) : LibC::Int
  fun oid_fromstrp = git_oid_fromstrp(out : Oid*, str : LibC::Char*) : LibC::Int
  fun oid_fromstrn = git_oid_fromstrn(out : Oid*, str : LibC::Char*, length : LibC::SizeT) : LibC::Int
  fun oid_fromraw = git_oid_fromraw(out : Oid*, raw : UInt8*)
  fun oid_fmt = git_oid_fmt(out : LibC::Char*, id : Oid*)
  fun oid_nfmt = git_oid_nfmt(out : LibC::Char*, n : LibC::SizeT, id : Oid*)
  fun oid_pathfmt = git_oid_pathfmt(out : LibC::Char*, id : Oid*)
  fun oid_tostr_s = git_oid_tostr_s(oid : Oid*) : LibC::Char*
  fun oid_tostr = git_oid_tostr(out : LibC::Char*, n : LibC::SizeT, id : Oid*) : LibC::Char*
  fun oid_cpy = git_oid_cpy(out : Oid*, src : Oid*)
  fun oid_cmp = git_oid_cmp(a : Oid*, b : Oid*) : LibC::Int
  fun oid_equal = git_oid_equal(a : Oid*, b : Oid*) : LibC::Int
  fun oid_ncmp = git_oid_ncmp(a : Oid*, b : Oid*, len : LibC::SizeT) : LibC::Int
  fun oid_streq = git_oid_streq(id : Oid*, str : LibC::Char*) : LibC::Int
  fun oid_strcmp = git_oid_strcmp(id : Oid*, str : LibC::Char*) : LibC::Int
  fun oid_iszero = git_oid_iszero(id : Oid*) : LibC::Int

  type OidShorten = Void*

  fun oid_shorten_new = git_oid_shorten_new(min_length : LibC::SizeT) : OidShorten
  fun oid_shorten_add = git_oid_shorten_add(os : OidShorten, text_id : LibC::Char*) : LibC::Int
  fun oid_shorten_free = git_oid_shorten_free(os : OidShorten)
end
