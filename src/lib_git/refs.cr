@[Link("git2")]
lib LibGit
  type Reference = Void*

  enum RefT
    Invalid  = 0
    Oid      = 1
    Symbolic = 2
    Listall  = 3
  end

  fun reference_lookup = git_reference_lookup(out : Reference*, repo : Repository, name : LibC::Char*) : LibC::Int
  fun reference_resolve = git_reference_resolve(out : Reference*, ref : Reference) : LibC::Int
  fun reference_owner = git_reference_owner(ref : Reference) : Repository
  fun reference_type = git_reference_type(ref : Reference) : RefT
  fun reference_name = git_reference_name(ref : Reference) : LibC::Char*
  fun reference_target = git_reference_target(ref : Reference) : Oid*
  fun reference_symbolic_target = git_reference_symbolic_target(ref : Reference) : LibC::Char*
  fun reference_free = git_reference_free(ref : Reference)

  fun reference_is_branch = git_reference_is_branch(ref : Reference) : LibC::Int
  fun reference_is_remote = git_reference_is_remote(ref : Reference) : LibC::Int
  fun reference_is_tag = git_reference_is_tag(ref : Reference) : LibC::Int
  fun reference_is_note = git_reference_is_note(ref : Reference) : LibC::Int
  fun reference_peel = git_reference_peel(out : Object*, ref : Reference, type : OType) : LibC::Int
  fun reference_is_valid_name = git_reference_is_valid_name(refname : LibC::Char*) : LibC::Int

  type ReferenceIterator = Void*

  fun reference_iterator_new = git_reference_iterator_new(out : ReferenceIterator*, repo : Repository) : LibC::Int
  fun reference_iterator_glob_new = git_reference_iterator_glob_new(out : ReferenceIterator*, repo : Repository, glob : LibC::Char*) : LibC::Int
  fun reference_next = git_reference_next(out : Reference*, iter : ReferenceIterator) : LibC::Int
  fun reference_next_name = git_reference_next_name(out : LibC::Char**, iter : ReferenceIterator) : LibC::Int
  fun reference_iterator_free = git_reference_iterator_free(iter : ReferenceIterator)
end
