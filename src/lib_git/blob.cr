@[Link("git2")]
lib LibGit
  type Blob = Void*

  fun blob_lookup = git_blob_lookup(blob : Blob*, repo : Repository, id : Oid*) : LibC::Int
  fun blob_lookup_prefix = git_blob_lookup_prefix(blob : Blob*, repo : Repository, id : Oid*, len : LibC::SizeT) : LibC::Int
  fun blob_free = git_blob_free(blob : Blob)
  fun blob_id = git_blob_id(blob : Blob) : Oid*
  fun blob_owner = git_blob_owner(blob : Blob) : Repository
  fun blob_rawcontent = git_blob_rawcontent(blob : Blob) : Void*
  fun blob_rawsize = git_blob_rawsize(blob : Blob) : OffT
  fun blob_filtered_content = git_blob_filtered_content(out : Buf*, blob : Blob, as_path : LibC::Char*, check_for_binary_data : LibC::Int) : LibC::Int
  fun blob_create_fromworkdir = git_blob_create_fromworkdir(id : Oid*, repo : Repository, relative_path : LibC::Char*) : LibC::Int
  fun blob_create_fromdisk = git_blob_create_fromdisk(id : Oid*, repo : Repository, path : LibC::Char*) : LibC::Int
  # fun blob_create_fromstream = git_blob_create_fromstream(out : Writestream**, repo : Repository, hintpath : LibC::Char*) : LibC::Int
  # fun blob_create_fromstream_commit = git_blob_create_fromstream_commit(out : Oid*, stream : Writestream*) : LibC::Int
  fun blob_create_frombuffer = git_blob_create_frombuffer(id : Oid*, repo : Repository, buffer : Void*, len : LibC::SizeT) : LibC::Int
  fun blob_is_binary = git_blob_is_binary(blob : Blob) : LibC::Int
  fun blob_dup = git_blob_dup(out : Blob*, source : Blob) : LibC::Int
end
