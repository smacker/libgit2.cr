require "./spec_helper"

describe Git::Commit do
  repo = FixtureRepo.from_rugged("testrepo.git")

  describe "test read commit data" do
    oid = "8496071c1b46c854b31185ea97743be6a8774479"
    obj = repo.lookup_commit(oid)

    it "should return correct main data" do
      obj.sha.should eq oid
      obj.message.should eq "testing\n"
      obj.time.to_unix.should eq 1273360386
      obj.epoch_time.should eq 1273360386
    end

    it "should return correct commiter data" do
      c = obj.committer
      c.name.should eq "Scott Chacon"
      c.epoch_time.should eq 1273360386
      c.email.should eq "schacon@gmail.com"
    end

    it "should return correct author data" do
      c = obj.author
      c.name.should eq "Scott Chacon"
      c.epoch_time.should eq 1273360386
      c.time.to_unix.should eq 1273360386
      c.email.should eq "schacon@gmail.com"
    end

    it "should return correct tree" do
      obj.tree.oid.to_s.should eq "181037049a54a1eb5fab404658a3a250b44335d7"
    end

    it "should return correct parents" do
      obj.parents.size.should eq(0)
    end
  end

  it "should get parent count" do
    oid = "a4a7dce85cf63874e984719f4fdd239f5145052f"
    obj = repo.lookup_commit(oid)
    obj.parent_count.should eq(2)
  end

  it "should get parent" do
    oid = "a4a7dce85cf63874e984719f4fdd239f5145052f"
    obj = repo.lookup_commit(oid)
    obj.parent.oid.to_s.should eq("c47800c7266a2be04c571c04d5a6614691ea99bd")
    obj.parent(0).oid.to_s.should eq("c47800c7266a2be04c571c04d5a6614691ea99bd")
    obj.parent(1).oid.to_s.should eq("9fd738e8f7967c078dceed8190330fc8648ee56a")
  end

  it "test commit with multiple parents" do
    oid = "a4a7dce85cf63874e984719f4fdd239f5145052f"
    obj = repo.lookup_commit(oid)
    parents = obj.parents.map { |c| c.oid.to_s }
    parents.includes?("9fd738e8f7967c078dceed8190330fc8648ee56a").should be_true
    parents.includes?("c47800c7266a2be04c571c04d5a6614691ea99bd").should be_true
  end

  pending "should get parent oids" do
    oid = "a4a7dce85cf63874e984719f4fdd239f5145052f"
    obj = repo.lookup_commit(oid)
    parents = obj.parent_oids
    parents.includes?("9fd738e8f7967c078dceed8190330fc8648ee56a").should be_true
    parents.includes?("c47800c7266a2be04c571c04d5a6614691ea99bd").should be_true
  end

  pending "should get tree oid" do
    oid = "8496071c1b46c854b31185ea97743be6a8774479"
    obj = repo.lookup_commit(oid)

    obj.tree_oid.should eq("181037049a54a1eb5fab404658a3a250b44335d7")
  end

  it "amend" do
    obj = repo.lookup_commit("8496071c1b46c854b31185ea97743be6a8774479")

    builder = Git::TreeBuilder.new(repo)
    builder.insert("README.txt", "1385f264afb75a56a5bec74243be9b367ba4ca08", Git::Filemode::FilemodeBlob)
    tree_oid = builder.write
    tree = repo.lookup_tree(tree_oid)

    person = Git::Signature.new(name = "Scott", email = "schacon@gmail.com", time = Time.now)

    commit_params = Git::AmendData.new(
      message: "This is the amended commit message\n\nThis commit is created from Rugged",
      committer: person,
      author: person,
      tree: tree,
    )

    new_commit_oid = obj.amend(commit_params)

    amended_commit = repo.lookup_commit(new_commit_oid)
    amended_commit.message.should eq(commit_params.message)
    amended_commit.tree.oid.should eq(tree_oid)
    amended_commit.committer.name.should eq(person.name)
    amended_commit.committer.email.should eq(person.email)
    amended_commit.author.name.should eq(person.name)
    amended_commit.author.email.should eq(person.email)
  end

  it "amend blank tree" do
    obj = repo.lookup_commit("8496071c1b46c854b31185ea97743be6a8774479")

    person = Git::Signature.new(name = "Scott", email = "schacon@gmail.com", time = Time.now)
    commit_params = Git::AmendData.new(
      message: "This is the amended commit message\n\nThis commit is created from Rugged",
      committer: person,
      author: person,
    )

    new_commit_oid = obj.amend(commit_params)

    amended_commit = repo.lookup_commit(new_commit_oid)
    amended_commit.message.should eq(commit_params.message)
    amended_commit.tree.oid.should eq(obj.tree.oid)
    amended_commit.committer.name.should eq(person.name)
    amended_commit.committer.email.should eq(person.email)
    amended_commit.author.name.should eq(person.name)
    amended_commit.author.email.should eq(person.email)
  end

  it "amend blank author and committer" do
    obj = repo.lookup_commit("8496071c1b46c854b31185ea97743be6a8774479")

    commit_params = Git::AmendData.new(
      message: "This is the amended commit message\n\nThis commit is created from Rugged",
    )

    new_commit_oid = obj.amend(commit_params)

    amended_commit = repo.lookup_commit(new_commit_oid)
    amended_commit.message.should eq(commit_params.message)
    amended_commit.tree.oid.should eq(obj.tree.oid)
    amended_commit.committer.name.should eq(obj.committer.name)
    amended_commit.committer.email.should eq(obj.committer.email)
    amended_commit.author.name.should eq(obj.committer.name)
    amended_commit.author.email.should eq(obj.author.email)
  end

  it "amend blank amessage" do
    obj = repo.lookup_commit("8496071c1b46c854b31185ea97743be6a8774479")

    person = Git::Signature.new(name = "Scott", email = "schacon@gmail.com", time = Time.now)
    commit_params = Git::AmendData.new(
      committer: person,
      author: person,
    )

    new_commit_oid = obj.amend(commit_params)

    amended_commit = repo.lookup_commit(new_commit_oid)
    amended_commit.message.should eq(obj.message)
    amended_commit.tree.oid.should eq(obj.tree.oid)
    amended_commit.committer.name.should eq(person.name)
    amended_commit.committer.email.should eq(person.email)
    amended_commit.author.name.should eq(person.name)
    amended_commit.author.email.should eq(person.email)
  end

  describe "write commit data" do
    source_repo = FixtureRepo.from_rugged("testrepo.git")
    write_repo = FixtureRepo.clone(source_repo)
    # repo.config['core.abbrev'] = 7

    msg = "This is the commit message\n\nThis commit is created from Rugged"
    tree = write_repo.lookup_tree("c4dc1555e4d4fa0e0c9c3fc46734c7c35b3ce90b")

    it "with time" do
      parent = write_repo.head.target.as(Git::Commit)
      person = Git::Signature.new(name = "Scott", email = "schacon@gmail.com", time = Time.now)
      data = Git::CommitData.new(
        message = msg,
        parents = [parent],
        tree,
        committer = person,
        author = person,
      )
      oid = Git::Commit.create(write_repo, data)

      commit = write_repo.lookup_commit(oid)
      commit.message.should eq(msg)
      commit.parent_count.should eq(1)
      commit.parent.should eq(parent)
      commit.time.should eq(person.time)
      commit.tree.should eq(tree)
      commit.author.name.should eq(person.name)
      commit.author.email.should eq(person.email)
      commit.committer.name.should eq(person.name)
      commit.committer.email.should eq(person.email)
    end

    pending "with time offset" do
    end

    it "without time" do
      parent = write_repo.head.target.as(Git::Commit)
      person = Git::Signature.new(name = "Scott", email = "schacon@gmail.com")
      data = Git::CommitData.new(
        message = msg,
        parents = [parent],
        tree,
        committer = person,
        author = person,
      )
      oid = Git::Commit.create(write_repo, data)

      commit = write_repo.lookup_commit(oid)
      commit.committer.time.should be_close(Time.now, 1.seconds)
    end

    pending "without signature" do
    end

    it "empty email fails" do
      expect_raises(Git::Error) do
        Git::Signature.new(name = "Scott", email = "", time = Time.now)
      end
    end

    it "to string" do
      parent = write_repo.head.target.as(Git::Commit)
      person = Git::Signature.new(name = "Scott", email = "schacon@gmail.com", time = Time.now)
      data = Git::CommitData.new(
        message = msg,
        parents = [parent],
        tree,
        committer = person,
        author = person
      )
      oid = Git::Commit.create(write_repo, data)
      buffer = Git::Commit.create_to_s(write_repo, data)

      commit = write_repo.lookup_commit(oid)
      buffer.should eq(commit.read_raw.data)
    end
  end
end
