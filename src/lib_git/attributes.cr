@[Link("git2")]
lib LibGit
  # The attribute has been left unspecified
  AttrUnspecifiedT = 0_i64
  # The attribute has been set
  AttrTrueT = 1_i64
  # The attribute has been unset
  AttrFalseT = 2_i64
  # This attribute has a value
  AttrValueT = 3_i64
  # Return the value type for a given attribute.
  fun attr_value = git_attr_value(attr : LibC::Char*) : AttrT
  # Possible states for an attribute
  enum AttrT
    # The attribute has been left unspecified
    AttrUnspecifiedT = 0
    # The attribute has been set
    AttrTrueT = 1
    # The attribute has been unset
    AttrFalseT = 2
    # This attribute has a value
    AttrValueT = 3
  end
  # Look up the value of one git attribute for path.
  fun attr_get = git_attr_get(value_out : LibC::Char**, repo : Repository, flags : Uint32T, path : LibC::Char*, name : LibC::Char*) : LibC::Int
  # Look up a list of git attributes for path.
  fun attr_get_many = git_attr_get_many(values_out : LibC::Char**, repo : Repository, flags : Uint32T, path : LibC::Char*, num_attr : LibC::SizeT, names : LibC::Char**) : LibC::Int
  # Loop over all the git attributes for a path.
  fun attr_foreach = git_attr_foreach(repo : Repository, flags : Uint32T, path : LibC::Char*, callback : AttrForeachCb, payload : Void*) : LibC::Int
  alias AttrForeachCb = (LibC::Char*, LibC::Char*, Void* -> LibC::Int)
  # Flush the gitattributes cache.
  fun attr_cache_flush = git_attr_cache_flush(repo : Repository)
  # Add a macro definition.
  fun attr_add_macro = git_attr_add_macro(repo : Repository, name : LibC::Char*, values : LibC::Char*) : LibC::Int
end
