require "../src/git"

if ARGV.size != 2
  puts "Usage: #{PROGRAM_NAME} PATH_TO_REPO PATH_TO_FILE"
  exit 1
end

repo_path, file_path = ARGV
puts repo_path
puts file_path
full_path = Path.new(repo_path, file_path)
puts full_path
lines = File.read_lines(full_path)
width = lines.size.to_s.size

repo = Git::Repo.open(repo_path)
blame = Git::Blame.new(repo, file_path)

row = 0
blame.each {|hunk|
  short_sha = hunk.orig_commit_id.to_s[0, 7]
  (1..hunk.lines_in_hunk).each {
    row += 1
    printf "%s %#{width}s) %s\n", short_sha, row, lines[row-1]
  }
}

