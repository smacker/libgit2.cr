@[Link("git2")]
lib LibGit
  struct Buf
    ptr : LibC::Char*
    asize : LibC::SizeT
    size : LibC::SizeT
  end

  fun buf_free = git_buf_free(buffer : Buf*)
end
