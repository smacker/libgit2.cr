@[Link("git2")]
lib LibGit
  type Blame = Void*

  struct BlameOptions
    version : LibC::UInt
    flags : Uint32T
    min_match_characters : Uint16T
    newest_commit : Oid
    oldest_commit : Oid
    min_line : LibC::SizeT
    max_line : LibC::SizeT
  end

  fun blame_init_options = git_blame_init_options(opts : BlameOptions*, version : LibC::UInt) : LibC::Int

  struct BlameHunk
    lines_in_hunk : LibC::SizeT
    final_commit_id : Oid
    final_start_line_number : LibC::SizeT
    final_signature : Signature*
    orig_commit_id : Oid
    orig_path : LibC::Char*
    orig_start_line_number : LibC::SizeT
    orig_signature : Signature*
    boundary : LibC::Char
  end

  fun blame_get_hunk_count = git_blame_get_hunk_count(blame : Blame) : Uint32T
  fun blame_get_hunk_byindex = git_blame_get_hunk_byindex(blame : Blame, index : Uint32T) : BlameHunk*
  fun blame_get_hunk_byline = git_blame_get_hunk_byline(blame : Blame, lineno : LibC::SizeT) : BlameHunk*
  fun blame_file = git_blame_file(out : Blame*, repo : Repository, path : LibC::Char*, options : BlameOptions*) : LibC::Int
  fun blame_buffer = git_blame_buffer(out : Blame*, reference : Blame, buffer : LibC::Char*, buffer_len : LibC::SizeT) : LibC::Int
  fun blame_free = git_blame_free(blame : Blame)
end
