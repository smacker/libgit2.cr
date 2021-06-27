require "option_parser"
require "../src/git"

repo_path = ""
show_log_size = false
sorting = Git::Sort::Time

OptionParser.parse do |parser|
  parser.banner = "Usage: log repo_path"
  parser.unknown_args do |p|
    if p.size != 1
      STDERR.puts parser
      exit(1)
    end
    repo_path = p[0]
  end
  parser.on(
    "--date-order",
    "Show no parents before all of its children are shown, but otherwise show commits in the commit timestamp order."
  ) { sorting = Git::Sort::Time | (sorting & Git::Sort::Reverse) }
  parser.on(
    "--topo-order",
    "Show no parents before all of its children are shown, and avoid showing commits on multiple lines of history intermixed."
  ) { sorting = Git::Sort::Topological | (sorting & Git::Sort::Reverse) }
  parser.on(
    "--reverse",
    "Output the commits chosen to be shown (see Commit Limiting section above) in reverse order."
  ) { sorting = sorting ^ Git::Sort::Reverse }
  parser.on(
    "--log-size",
    "Include a line \"log size <number>\" in the output for each commit, where <number> is the length of thatcommit's message in bytes."
  ) { show_log_size = true }
  parser.on("-h", "--help", "Show this help") { puts parser }
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

repo = Git::Repo.open(repo_path)
repo.walk(repo.head.target_id, sorting) do |commit|
  puts "commit #{commit}"
  puts "log size #{commit.message.size}" if show_log_size
  if commit.parent_count > 1
    puts "Merge: #{commit.parents.join(" ")}"
  end
  author = commit.author
  puts "Author: #{author.name} <#{author.email}>"
  puts "Date:   #{author.time}"
  puts ""
  puts commit.message
  puts ""
end
