# libgit2.cr

Crystal-lang binding to [libgit2](https://libgit2.org) with inteface similar to [rugged](https://github.com/libgit2/rugged/).

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  git:
    github: smacker/libgit2.cr
```

## Usage

```crystal
require "git"
```

TODO: Write usage instructions here

## STATUS

- [ ] Documentation
- [ ] Backend
- [ ] Blame
  - [x] `#[]/#fetch`
  - [x] `#size`
  - [x] `#each`
  - [ ] `#for_line`
- [ ] Blob
  - [x] `#binary?`
  - [x] `#content`
  - [ ] `#diff`
  - [ ] `#hashsig`
  - [ ] `#loc`
  - [ ] `#similarity`
  - [x] `#size`
  - [ ] `#sloc`
  - [x] `#text`
- [ ] Branch
  - [ ] `#==`
  - [x] `#name`
  - [ ] `#head?`
  - [ ] `#remote`
  - [ ] `#remote_name`
  - [ ] `#upstream`
  - [ ] `#upstream=`
- [ ] BranchCollection
  - [x] `#[]`
  - [ ] `#create`
  - [ ] `#delete`
  - [x] `#each`
  - [x] `#each_name`
  - [ ] `#exist?`
  - [ ] `#rename`
- [ ] Commit
  - [ ] `#amend`
  - [x] `#author`
  - [x] `#commiter`
  - [ ] `#diff`
  - [ ] `#diff_workdir`
  - [x] `#epoch_time`
  - [ ] `#header`
  - [ ] `#header_field`
  - [ ] `#header_field?`
  - [ ] `#inspect`
  - [x] `#message`
  - [ ] `#modify`
  - [ ] `#parent_ids`
  - [x] `#parents`
  - [ ] `#summary`
  - [x] `#time`
  - [ ] `#to_hash`
  - [ ] `#to_mbox`
  - [ ] `#trailers`
  - [x] `#tree`
  - [ ] `#tree_id`
- [ ] Config
- [ ] Credentials
- Diff (TODO: check what is implemented, something works)
- [ ] Index
- [ ] Patch
- [ ] Rebase
- [ ] Reference
  - [x] `#branch`
  - [ ] `#canonical_name`
  - [ ] `#inspect`
  - [ ] `#log`
  - [ ] `#log?`
  - [x] `#name`
  - [x] `#peel`
  - [x] `#remote?`
  - [x] `#resolve`
  - [x] `#tag?`
  - [x] `#target`
  - [x] `#target_id`
  - [x] `#type`
- [ ] ReferenceCollection
  - [x] `#[]`
  - [ ] `#create`
  - [ ] `#delete`
  - [x] `#each`
  - [x] `#each_name`
  - [x] `#exists?`
  - [ ] `#rename`
  - [ ] `#update`
- [ ] Remote
  - [ ] `check_connection`
  - [ ] `fetch`
  - [ ] `fetch_refspecs`
  - [x] `name`
  - [ ] `push`
  - [ ] `push_refspecs`
  - [x] `push_url`
  - [ ] `push_url=`
  - [x] `url`
- [ ] RemoteCollection
- [ ] Repository
  - [x] `#open`
  - [x] `#exists?`
  - [x] `#bare?`
  - [x] `#head`
  - [x] `#head?`
  - [x] `#lookup_commit`
  - [x] `#lookup_tag`
  - [x] `#lookup_tree`
  - [x] `#lookup_blob`
  - [x] `#branches`
  - [x] `#ref`
  - [x] `#refs`
  - [x] `#ref_names`
  - [x] `#tags`
  - [x] `#walk`
  - [ ] lots of other methods
- [ ] Settings
- [ ] Submodule
- [ ] SubmoduleCollection
- [ ] Tag
  - [ ] `#annotated?`
  - [x] `#name`
  - [x] `#message`
  - [x] `#target_type`
  - [x] `#target_oid`
  - [x] `#tagger`
- TagCollection
  - [x] `#[]`
  - [ ] `#create`
  - [ ] `#create_annotation`
  - [ ] `#delete`
  - [x] `#each`
  - [ ] `#each_name`
- [ ] Tree
  - [x] `#[]`
  - [x] `#size`
  - [x] `#cresize_recursiveate`
  - [x] `#diff`
  - [ ] `#diff_workdir`
  - [x] `#each`
  - [x] `#each_blob`
  - [x] `#each_tree`
  - [ ] `#merge`
  - [ ] `#path`
  - [ ] `#update`
  - [x] `#walk`
  - [x] `#walk_blobs`
  - [x] `#walk_trees`
- [ ] RevWalk
  - [ ] `#count`
  - [x] `#each`
  - [ ] `#each_oid`
  - [ ] `#hide`
  - [x] `#push`
  - [x] `#push_head`
  - [ ] `#push_range`
  - [ ] `#reset`
  - [x] `#simplify_first_parent`
  - [x] `#sorting`

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/smacker/libgit2/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [smacker](https://github.com/smacker) Maxim Sukharev - creator, maintainer
