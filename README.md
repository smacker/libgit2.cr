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
  - [x] `#loc`
  - [ ] `#similarity`
  - [x] `#size`
  - [x] `#sloc`
  - [x] `#text`
  - [x] `from_buffer`
- [ ] Branch
  - [ ] `#==`
  - [x] `#name`
  - [x] `#head?`
  - [ ] `#remote`
  - [ ] `#remote_name`
  - [ ] `#upstream`
  - [ ] `#upstream=`
- [ ] BranchCollection
  - [x] `#[]`
  - [x] `#create`
  - [ ] `#delete`
  - [x] `#each`
  - [x] `#each_name`
  - [ ] `#exist?`
  - [ ] `#rename`
- [ ] Commit
  - [x] `.create`
  - [x] `#amend`
  - [x] `#author`
  - [x] `#commiter`
  - [x] `#diff`
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
- [ ] Diff
  - [ ] Delta
    - [ ] `#binary`
    - [x] `#old_file`
    - [x] `#new_file`
    - [ ] `#owner`
    - [ ] `#similarity`
    - [x] `#status`
    - [ ] `#status_char`
    - [x] `#added?`
    - [ ] `#copied?`
    - [x] `#deleted?`
    - [ ] `#ignored?`
    - [x] `#modified?`
    - [ ] `#renamed?`
    - [ ] `#typechange?`
    - [ ] `#untracked?`
  - [ ] Hunk
    - [ ] `#header`
    - [ ] `#hunk_index`
    - [ ] `#line_count`
    - [x] `#new_lines`
    - [x] `#new_start`
    - [x] `#old_lines`
    - [x] `#old_start`
    - [ ] `#delta`
    - [ ] `#each`
    - [ ] `#each_line`
    - [x] `#lines`
  - [ ] Line
    - [x] `#content`
    - [x] `#content_offset`
    - [ ] `#line_origin`
    - [x] `#new_lineno`
    - [x] `#old_lineno`
    - [x] `#addition?`
    - [ ] `#binary?`
    - [x] `#context?`
    - [x] `#deletion?`
    - [ ] `#eof_newline_added?`
    - [ ] `#eof_newline_removed?`
    - [ ] `#eof_no_newline?`
    - [ ] `#file_header?`
    - [ ] `#hunk_header?`
  - [ ] `#owner`
  - [x] `#deltas`
  - [x] `#each_delta`
  - [ ] `#each_line`
  - [x] `#each_patch`
  - [x] `#find_similar!`
  - [ ] `#merge!`
  - [ ] `#patch`
  - [x] `#patches`
  - [x] `#size`
  - [ ] `#sorted_icase?`
  - [ ] `#stat`
  - [ ] `#write_patch`
- [ ] Index
- [ ] Object
  - [x] `.lookup`
  - [ ] `.rev_parse`
  - [ ] `.rev_parse_oid`
  - [ ] `#create_note`
  - [ ] `#notes`
  - [x] `#oid`
  - [x] `#read_raw`
  - [ ] `#remove_note`
  - [x] `#type`
- [ ] OdbObjet
  - [x] `#data`
  - [ ] `#size`
  - [x] `#oid`
  - [ ] `#type`
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
