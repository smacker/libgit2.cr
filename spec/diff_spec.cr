require "./spec_helper"

describe Git::Diff do
  it "basic diff" do
    repo = FixtureRepo.from_libgit2("attr")
    a = Git::Commit.lookup(repo, "605812a").tree
    b = Git::Commit.lookup(repo, "370fe9ec22").tree
    c = Git::Commit.lookup(repo, "f5b0af1fb4f5c").tree

    diff = a.diff(b) # , :context_lines => 1, :interhunk_lines => 1
    deltas = diff.deltas
    patches = diff.patches

    # hunks = patches.map(&.hunks).flatten
    hunks = patches.map do |p|
      arr = [] of Git::DiffHunk
      p.hunks { |l| arr << l }
      arr
    end
    hunks = hunks.flatten

    # lines = hunks.as(Array(Git::DiffHunk)).map(&.lines).flatten
    lines = hunks.as(Array(Git::DiffHunk)).map do |h|
      arr = [] of Git::DiffLine
      h.lines { |l| arr << l }
      arr
    end
    lines = lines.flatten

    diff.size.should eq(5)
    deltas.size.should eq(5)
    patches.size.should eq(5)

    deltas.select(&.added?).size.should eq(2)
    deltas.select(&.deleted?).size.should eq(1)
    deltas.select(&.modified?).size.should eq(2)

    hunks.size.should eq(5)

    lines.size.should eq(7 + 24 + 1 + 6 + 6)
    lines.select(&.context?).size.should eq(1)
    lines.select(&.addition?).size.should eq(24 + 1 + 5 + 5)
    lines.select(&.deletion?).size.should eq(7 + 1)

    diff = c.diff(b) # , :context_lines => 1, :interhunk_lines => 1
    deltas = diff.deltas
    patches = diff.patches
    # hunks = patches.map(&.hunks).flatten
    hunks = patches.map do |p|
      arr = [] of Git::DiffHunk
      p.hunks { |l| arr << l }
      arr
    end
    hunks = hunks.flatten

    # lines = hunks.as(Array(Git::DiffHunk)).map(&.lines).flatten
    lines = hunks.as(Array(Git::DiffHunk)).map do |h|
      arr = [] of Git::DiffLine
      h.lines { |l| arr << l }
      arr
    end
    lines = lines.flatten

    deltas.size.should eq(2)
    patches.size.should eq(2)

    deltas.select(&.added?).size.should eq(0)
    deltas.select(&.deleted?).size.should eq(0)
    deltas.select(&.modified?).size.should eq(2)

    hunks.size.should eq(2)

    lines.size.should eq(8 + 15)
    lines.select(&.context?).size.should eq(1)
    lines.select(&.addition?).size.should eq(1)
    lines.select(&.deletion?).size.should eq(7 + 14)
  end

  it "diff with empty tree" do
    repo = FixtureRepo.from_libgit2("attr")
    a = Git::Commit.lookup(repo, "605812a").tree

    diff = a.diff(nil) # , :context_lines => 1, :interhunk_lines => 1

    deltas = diff.deltas
    patches = diff.patches
    # hunks = patches.map(&.hunks).flatten
    hunks = patches.map do |p|
      arr = [] of Git::DiffHunk
      p.hunks { |l| arr << l }
      arr
    end
    hunks = hunks.flatten

    # lines = hunks.as(Array(Git::DiffHunk)).map(&.lines).flatten
    lines = hunks.as(Array(Git::DiffHunk)).map do |h|
      arr = [] of Git::DiffLine
      h.lines { |l| arr << l }
      arr
    end
    lines = lines.flatten

    diff.size.should eq(16)
    deltas.size.should eq(16)
    patches.size.should eq(16)

    deltas.select(&.added?).size.should eq(0)
    deltas.select(&.deleted?).size.should eq(16)
    deltas.select(&.modified?).size.should eq(0)

    hunks.size.should eq(15)

    lines.size.should eq(115)
    lines.select(&.context?).size.should eq(0)
    lines.select(&.addition?).size.should eq(0)
    lines.select(&.deletion?).size.should eq(113)
  end
  
  it "patch and to_s" do
    repo = FixtureRepo.from_libgit2("attr")
    a = Git::Commit.lookup(repo, "605812a").tree
    b = Git::Commit.lookup(repo, "370fe9ec22").tree
    #c = Git::Commit.lookup(repo, "f5b0af1fb4f5c").tree
    
    diff = a.diff(b)
    
    deltas = diff.deltas
    
    patches = diff.patches
    
    deltas = patches.map { |p| p.delta }
    
    deltas.size.should eq(5)
    
    patch = patches.first
    patch.to_s.should contain("diff --git a/.gitattributes b/.gitattributes")
  end
end
