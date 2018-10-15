@[Link("git2")]
lib LibGit
  type Tag = Void*

  fun tag_lookup = git_tag_lookup(out : Tag*, repo : Repository, id : Oid*) : LibC::Int
  fun tag_lookup_prefix = git_tag_lookup_prefix(out : Tag*, repo : Repository, id : Oid*, len : LibC::SizeT) : LibC::Int
  fun tag_free = git_tag_free(tag : Tag)
  fun tag_id = git_tag_id(tag : Tag) : Oid*
  fun tag_owner = git_tag_owner(tag : Tag) : Repository
  fun tag_target = git_tag_target(target_out : Object*, tag : Tag) : LibC::Int
  fun tag_target_id = git_tag_target_id(tag : Tag) : Oid*
  fun tag_target_type = git_tag_target_type(tag : Tag) : OType
  fun tag_name = git_tag_name(tag : Tag) : LibC::Char*
  fun tag_tagger = git_tag_tagger(tag : Tag) : Signature*
  fun tag_message = git_tag_message(tag : Tag) : LibC::Char*
  fun tag_create = git_tag_create(oid : Oid*, repo : Repository, tag_name : LibC::Char*, target : Object, tagger : Signature*, message : LibC::Char*, force : LibC::Int) : LibC::Int
  fun tag_annotation_create = git_tag_annotation_create(oid : Oid*, repo : Repository, tag_name : LibC::Char*, target : Object, tagger : Signature*, message : LibC::Char*) : LibC::Int
  fun tag_create_frombuffer = git_tag_create_frombuffer(oid : Oid*, repo : Repository, buffer : LibC::Char*, force : LibC::Int) : LibC::Int
  fun tag_create_lightweight = git_tag_create_lightweight(oid : Oid*, repo : Repository, tag_name : LibC::Char*, target : Object, force : LibC::Int) : LibC::Int
  fun tag_delete = git_tag_delete(repo : Repository, tag_name : LibC::Char*) : LibC::Int
  fun tag_list = git_tag_list(tag_names : Strarray*, repo : Repository) : LibC::Int
  fun tag_list_match = git_tag_list_match(tag_names : Strarray*, pattern : LibC::Char*, repo : Repository) : LibC::Int
end
