require "./spec_helper"

describe Git::Blame do
  repo = FixtureRepo.from_libgit2("testrepo")
  blame = Git::Blame.new(repo, "branch_file.txt")

  pending "#[]" do
    blame.size.should eq(2)

    expected = Git::Blame::Hunk.new
    expected.lines_in_hunk = 1
    expected.final_commit_id = Git::Oid.new("c47800c7266a2be04c571c04d5a6614691ea99bd")
    expected.final_start_line_number = 2
    final_signature = LibGit::Signature.new
    final_signature.name = "Scott Chacon"
    final_signature.email = "schacon@gmail.com"
    expected.final_signature = pointerof(final_signature)
    expected.orig_commit_id = Git::Oid.new("c47800c7266a2be04c571c04d5a6614691ea99bd")
    expected.orig_path = "branch_file.txt"
    expected.orig_start_line_number = 1
    orig_signature = LibGit::Signature.new
    orig_signature.name = "Scott Chacon"
    orig_signature.email = "schacon@gmail.com"
    expected.orig_signature = pointerof(orig_signature)
    expected.boundary = 0

    blame[0].should eq(expected)

    expected = Git::Blame::Hunk.new
    expected.lines_in_hunk = 1
    expected.final_commit_id = Git::Oid.new("a65fedf39aefe402d3bb6e24df4d4f5fe4547750")
    expected.final_start_line_number = 2
    final_signature = LibGit::Signature.new
    final_signature.name = "Scott Chacon"
    final_signature.email = "schacon@gmail.com"
    expected.final_signature = pointerof(final_signature)
    expected.orig_commit_id = Git::Oid.new("a65fedf39aefe402d3bb6e24df4d4f5fe4547750")
    expected.orig_path = "branch_file.txt"
    expected.orig_start_line_number = 2
    orig_signature = LibGit::Signature.new
    orig_signature.name = "Scott Chacon"
    orig_signature.email = "schacon@gmail.com"
    expected.orig_signature = pointerof(orig_signature)
    expected.boundary = 0

    blame[1].should eq(expected)
  end

  pending "#for_line" do
  end

  pending "#with_invalid_line" do
  end

  it "#each" do
    hunks = [] of Git::Blame::Hunk
    blame.each { |hunk| hunks.push(hunk) }
    hunks.size.should eq(2)

    hunks[0].should eq(blame[0])
    hunks[1].should eq(blame[1])
  end
end
