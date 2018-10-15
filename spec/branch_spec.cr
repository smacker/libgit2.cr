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

  pending "lookup with ambiguous names" do
    repo.branches["origin/master"].target_id.should eq("41bc8c69075bbdb46c5c6f0566cc8cc5b46e8bd9")
    repo.branches["heads/origin/master"].target_id.should eq("41bc8c69075bbdb46c5c6f0566cc8cc5b46e8bd9")
    repo.branches["remotes/origin/master"].target_id.should eq("36060c58702ed4c2a40832c51758d5344201d89a")

    repo.branches["refs/heads/origin/master"].target_id.should eq("41bc8c69075bbdb46c5c6f0566cc8cc5b46e8bd9")
    repo.branches["refs/remotes/origin/master"].target_id.should eq("36060c58702ed4c2a40832c51758d5344201d89a")
  end

  it "list only local branches" do
    repo.branches.each_name(Git::BranchType::Local).to_a.sort.should eq(["master"])
  end

  it "list only remote branches" do
    repo.branches.each_name(Git::BranchType::Remote).to_a.sort.should eq([
      "origin/HEAD",
      "origin/master",
      "origin/packed",
    ])
  end
end
