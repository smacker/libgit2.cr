require "../src/git"
if ARGV.size != 3
  puts "Usage: #{PROGRAM_NAME} PATH_TO_REPO SHA1 SHA2"
  exit 1
end

repo_path, sha1, sha2 = ARGV

repo = Git::Repo.open(repo_path)

old = Git::Commit.lookup(repo, sha1).tree
new = Git::Commit.lookup(repo, sha2).tree

diff = old.diff(new) # , :context_lines => 1, :interhunk_lines => 1
diff.each_delta {|delta|
  puts delta.old_file.path
}

diff.each_patch {|patch|
  puts patch.to_s
}
