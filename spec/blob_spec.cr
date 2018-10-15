require "./spec_helper"

describe Git::Blob do
  repo = FixtureRepo.from_rugged("testrepo.git")

  it "lookup raises error if object type does not match" do
    # FIXME more specific error

    expect_raises(Git::Error) do
      # commit
      Git::Blob.lookup(repo, "8496071c1b46c854b31185ea97743be6a8774479")
    end

    expect_raises(Git::Error) do
      # tag
      Git::Blob.lookup(repo, "0c37a5391bbff43c37f0d0371823a5509eed5b1d")
    end

    expect_raises(Git::Error) do
      # tree
      Git::Blob.lookup(repo, "c4dc1555e4d4fa0e0c9c3fc46734c7c35b3ce90b")
    end
  end

  it "read blob data" do
    oid = "fa49b077972391ad58037050f2a75f74e3671e92"
    blob = Git::Blob.lookup(repo, oid)
    blob.size.should eq(9)
    blob.content.should eq("new file\n")
    blob.type.should eq(Git::OType::BLOB)
    blob.oid.to_s.should eq(oid)
    blob.text.should eq("new file\n")
  end

  pending "sloc" do
    blob = Git::Blob.lookup(repo, "7771329dfa3002caf8c61a0ceb62a31d09023f37")
    blob.sloc.should eq(328)
  end

  it "content with size" do
    blob = Git::Blob.lookup(repo, "7771329dfa3002caf8c61a0ceb62a31d09023f37")
    content = blob.content(10)
    content.should eq("# Rugged\n*")
    content.size.should eq(10)
  end

  it "content with size gt file size" do
    blob = Git::Blob.lookup(repo, "7771329dfa3002caf8c61a0ceb62a31d09023f37")
    content = blob.content(1000000)
    content.size.should eq(blob.size)
  end

  it "content with zero size" do
    blob = Git::Blob.lookup(repo, "7771329dfa3002caf8c61a0ceb62a31d09023f37")
    content = blob.content(0)
    content.should eq("")
  end

  it "content with negative size" do
    blob = Git::Blob.lookup(repo, "7771329dfa3002caf8c61a0ceb62a31d09023f37")
    content = blob.content(-100)
    content.size.should eq(blob.size)
  end

  pending "text_with_max_lines" do
    blob = Git::Blob.lookup(repo, "7771329dfa3002caf8c61a0ceb62a31d09023f37")
    blob.text(1).should eq("# Rugged\n")
  end

  pending "text with lines gt file lines" do
    blob = Git::Blob.lookup(repo, "7771329dfa3002caf8c61a0ceb62a31d09023f37")
    text = blob.text(1000000)
    text.lines.size.should eq(464)
  end

  pending "text with zero lines" do
    blob = Git::Blob.lookup(repo, "7771329dfa3002caf8c61a0ceb62a31d09023f37")
    text = blob.text(0)
    text.should eq("")
  end

  pending "text_with_negative_lines" do
    blob = Git::Blob.lookup(repo, "7771329dfa3002caf8c61a0ceb62a31d09023f37")
    text = blob.text(-100)
    text.lines.size.should eq(464)
  end
end
