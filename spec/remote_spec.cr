require "./spec_helper"

describe Git::Remote do
  repo = FixtureRepo.from_libgit2("testrepo.git")

  it "should each" do
    repo.remotes.should be_a(Enumerable(Git::Remote))
    repo.remotes.map(&.name).to_a.sort.should eq([
      "empty-remote-pushurl",
      "empty-remote-url",
      "joshaber",
      "test",
      "test_with_pushurl",
    ])
  end

  it "shoud return url" do
    repo.remotes["test"].url.should eq("git://github.com/libgit2/libgit2")
    repo.remotes["empty-remote-url"].url.should be_nil
  end

  it "shoud return push_url" do
    repo.remotes["test_with_pushurl"].push_url.should eq("git@github.com:libgit2/pushlibgit2")
    repo.remotes["joshaber"].push_url.should be_nil
  end

  it "should lookout correctly" do
    remote = repo.remotes["test"]
    remote.url.should eq("git://github.com/libgit2/libgit2")
    remote.name.should eq("test")
  end

  it "should return nil for missing remote" do
    repo.remotes["missing_remote"]?.should be_nil
  end

  it "should raise error for incorrect remote" do
    expect_raises(Git::Error) do
      repo.remotes["*\?"]
    end
  end
end
