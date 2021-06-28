require "../src/git"

if ARGV.size != 1
  puts "Usage: #{PROGRAM_NAME} PATH_TO_REPO"
  exit 1
end

repo_path  = ARGV[0]

repo = Git::Repo.open(repo_path)

#repo.ref_names.each {|name|
#  puts name
#}
#exit

repo.refs.each {|ref|
  # ref is a Git::Reference
  sha = ""
  printf "%-30s ", ref.name
  case ref.target
  when Git::Tag::Annotation
    sha = ref.target_id
  when Git::Commit
    #commit = ref
    sha = ref.target.to_s
  when Git::Reference
    # sha = "reference"
    sha = ref.target_id  # refs/remotes/origin/master
    case ref.target_id
    when Git::Oid
      puts "oid"
    when String
      puts "string"
      #commit = Git::Commit.lookup(repo, ref.target_id)
    else
      raise Exception.new("Unhandled type for #{ref.target_id}")
    end
    puts typeof(sha)
    # puts "reference"
    # puts ref.target.to_s
    # puts ref.target_id
    # puts ref.target_id
    # puts ref.resolve # returns the same Git::Reference
    # puts ref.branch?
    # puts ref.remote?
    # puts ref.tag?
    # puts ref.target.to_s # is just the instance
    # puts "---"
  else
    raise "Unexpected target type #{ref.target.class}"
  end
  puts sha
}
