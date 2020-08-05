require "./spec_helper"

describe Git::Branch do
  source_repo = FixtureRepo.from_rugged("testrepo.git")
  repo = FixtureRepo.clone(source_repo)

  it "list all names" do
    repo.branches.each_name.to_a.sort.should eq([
      "master",
      "origin/HEAD",
      "origin/master",
      "origin/packed",
    ])
  end

  it "list only local branches" do
    repo.branches.each_name(Git::BranchType::Local).to_a.sort.should eq(["master"])
  end

  it "each accept a block" do
    branches = [] of Git::Branch
    repo.branches.each(:local) do |branch|
      branches << branch
    end
    branches.map(&.name).should eq(%w(master))
  end

  it "lookup with ambiguous names" do
    commit = repo.lookup_commit("41bc8c69075bbdb46c5c6f0566cc8cc5b46e8bd9")
    repo.branches.create("origin/master", commit)

    repo.branches["origin/master"].target_id.to_s.should eq("41bc8c69075bbdb46c5c6f0566cc8cc5b46e8bd9")
    repo.branches["heads/origin/master"].target_id.to_s.should eq("41bc8c69075bbdb46c5c6f0566cc8cc5b46e8bd9")
    repo.branches["remotes/origin/master"].target_id.to_s.should eq("36060c58702ed4c2a40832c51758d5344201d89a")

    repo.branches["refs/heads/origin/master"].target_id.to_s.should eq("41bc8c69075bbdb46c5c6f0566cc8cc5b46e8bd9")
    repo.branches["refs/remotes/origin/master"].target_id.to_s.should eq("36060c58702ed4c2a40832c51758d5344201d89a")
  end

  it "list only remote branches" do
    repo.branches.each_name(Git::BranchType::Remote).to_a.sort.should eq([
      "origin/HEAD",
      "origin/master",
      "origin/packed",
    ])
  end

  it "is_head" do
    repo.branches["master"].head?.should be_true
    repo.branches["origin/master"].head?.should be_false
    repo.branches["origin/packed"].head?.should be_false
    # repo.create_branch("test_branch").head?.should be_false
  end
end
