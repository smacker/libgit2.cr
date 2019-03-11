@[Link("git2")]
lib LibGit
  # crystal aliases
  alias Uint32T = LibC::UInt
  alias Uint16T = LibC::UShort

  # git aliases
  alias TimeT = LibC::LongLong
  alias OffT = LibC::LongLong

  struct Time
    time : TimeT
    offset : LibC::Int
  end

  struct Strarray
    strings : LibC::Char**
    count : LibC::SizeT
  end

  fun strarray_free = git_strarray_free(array : Strarray*)
  fun strarray_copy = git_strarray_copy(tgt : Strarray*, src : Strarray*) : LibC::Int

  struct Signature
    name : LibC::Char*
    email : LibC::Char*
    when : Time
  end

  fun signature_new = git_signature_new(out : Signature**, name : LibC::Char*, email : LibC::Char*, time : TimeT, offset : LibC::Int) : LibC::Int
  fun signature_now = git_signature_now(out : Signature**, name : LibC::Char*, email : LibC::Char*) : LibC::Int
  fun signature_free = git_signature_free(sig : Signature*)

  enum SubmoduleIgnoreT
    SubmoduleIgnoreUnspecified = -1
    SubmoduleIgnoreNone        =  1
    SubmoduleIgnoreUntracked   =  2
    SubmoduleIgnoreDirty       =  3
    SubmoduleIgnoreAll         =  4
  end

  fun libgit2_init = git_libgit2_init : LibC::Int
end
