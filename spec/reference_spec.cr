require "./spec_helper"

describe Git::Reference do
  repo = FixtureRepo.from_libgit2("testrepo")

  it "should validate ref name" do
    valid = "refs/foobar"
    invalid = "refs/~nope^*"

    Git::Reference.valid_name?(valid).should be_true
    Git::Reference.valid_name?(invalid).should be_false
  end

  it "each can handle exceptions" do
    expect_raises(Exception) do
      repo.refs.each do
        raise Exception.new("fail")
      end
    end
  end

  it "should get references list" do
    repo.refs.each.map(&.name).to_a.sort.should eq([
      "refs/heads/br2",
      "refs/heads/dir",
      "refs/heads/executable",
      "refs/heads/ident",
      "refs/heads/long-file-name",
      "refs/heads/master",
      "refs/heads/merge-conflict",
      "refs/heads/packed",
      "refs/heads/packed-test",
      "refs/heads/subtrees",
      "refs/heads/test",
      "refs/heads/testrepo-worktree",
      "refs/tags/e90810b",
      "refs/tags/foo/bar",
      "refs/tags/foo/foo/bar",
      "refs/tags/packed-tag",
      "refs/tags/point_to_blob",
      "refs/tags/test",
    ])
  end

  it "can filter refs with glob" do
    repo.refs("refs/tags/*").map(&.name).to_a.sort.should eq([
      "refs/tags/e90810b",
      "refs/tags/foo/bar",
      "refs/tags/foo/foo/bar",
      "refs/tags/packed-tag",
      "refs/tags/point_to_blob",
      "refs/tags/test",
    ])
  end

  it "can open reference" do
    ref = repo.refs["refs/heads/master"]
    ref.target_id
    ref.type.should eq(Git::RefType::Oid)
    ref.name.should eq("refs/heads/master")
    ref.canonical_name.should eq("refs/heads/master")
    ref.peel.should be_nil
  end

  it "can open a symbolic reference" do
    ref = repo.references["HEAD"]
    ref.target_id.should eq("refs/heads/master")
    ref.type.should eq(Git::RefType::Symbolic)

    resolved = ref.resolve
    resolved.type.should eq(Git::RefType::Oid)
    resolved.target_id.to_s.should eq("099fabac3a9ea935598528c27f866e34089c2eff")
    ref.peel.should eq(resolved.target_id)
  end

  it "looking up missing ref returns nil" do
    ref = repo.references["lol/wut"]?
    ref.should be_nil
  end

  it "reference exists" do
    repo.references.exists?("refs/heads/master").should be_true
    repo.references.exists?("lol/wut").should be_false
  end

  it "test_load_packed_ref" do
    ref = repo.references["refs/heads/packed"]
    ref.target_id.to_s.should eq("41bc8c69075bbdb46c5c6f0566cc8cc5b46e8bd9")
    ref.type.should eq(Git::RefType::Oid)
    ref.name.should eq("refs/heads/packed")
  end

  it "test_resolve_head" do
    ref = repo.references["HEAD"]
    ref.target_id.should eq("refs/heads/master")
    ref.type.should eq(Git::RefType::Symbolic)

    head = ref.resolve
    head.target_id.to_s.should eq ("099fabac3a9ea935598528c27f866e34089c2eff")
    head.type.should eq(Git::RefType::Oid)
  end

  it "test_reference_to_tag" do
    ref = repo.references["refs/tags/test"]

    ref.target_id.to_s.should eq("b25fa35b38051e4ae45d4222e795f9df2e43f1d1")
    ref.peel.to_s.should eq("e90810b8df3e80c413d903f631643c716887138d")
  end

  it "test_reference_is_branch" do
    repo = FixtureRepo.from_libgit2("testrepo.git")

    repo.references["refs/heads/master"].branch?.should be_true

    repo.references["refs/remotes/test/master"].branch?.should be_false
    repo.references["refs/tags/test"].branch?.should be_false
  end

  it "test_reference_is_remote" do
    repo = FixtureRepo.from_libgit2("testrepo.git")

    repo.references["refs/remotes/test/master"].remote?.should be_true

    repo.references["refs/heads/master"].remote?.should be_false
    repo.references["refs/tags/test"].remote?.should be_false
  end

  it "test_reference_is_tag" do
    repo = FixtureRepo.from_libgit2("testrepo.git")

    repo.references["refs/tags/test"].tag?.should be_true

    repo.references["refs/heads/master"].tag?.should be_false
    repo.references["refs/remotes/test/master"].tag?.should be_false
  end
end
