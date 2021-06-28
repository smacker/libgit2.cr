require "../src/git"

if ARGV.size != 2
  puts "Usage: #{PROGRAM_NAME} PATH_TO_REPO SHA1"
  exit 1
end

repo_path, sha1 = ARGV

repo = Git::Repo.open(repo_path)
# commit = repo.lookup_commit(sha1) # only handles full 40-characters long SHA1
commit = Git::Commit.lookup(repo, sha1) # Can handle partial prefix of SHA1 as well
puts typeof(commit)
puts "sha: #{commit.sha}"
puts "message: #{commit.message}"
puts "unix: #{commit.time.to_unix}"
puts "epoch: #{commit.epoch_time}"

committer = commit.committer
puts "committer.name: #{committer.name}"
puts "committer.epuch_time: #{committer.epoch_time}"
puts "committer.email: #{committer.email}"

