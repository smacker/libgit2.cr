@[Link("git2")]
lib LibGit
  enum ErrorCode
    Ok              =   0
    Error           =  -1
    Enotfound       =  -3
    Eexists         =  -4
    Eambiguous      =  -5
    Ebufs           =  -6
    Euser           =  -7
    Ebarerepo       =  -8
    Eunbornbranch   =  -9
    Eunmerged       = -10
    Enonfastforward = -11
    Einvalidspec    = -12
    Econflict       = -13
    Elocked         = -14
    Emodified       = -15
    Eauth           = -16
    Ecertificate    = -17
    Eapplied        = -18
    Epeel           = -19
    Eeof            = -20
    Einvalid        = -21
    Euncommitted    = -22
    Edirectory      = -23
    Emergeconflict  = -24
    Passthrough     = -30
    Iterover        = -31
  end

  struct Error
    message : LibC::Char*
    klass : LibC::Int
  end

  fun err_last = giterr_last : Error
end
