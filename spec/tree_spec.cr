require "./spec_helper"

describe Git::Tree do
  repo = FixtureRepo.from_rugged("testrepo.git")
  oid = "c4dc1555e4d4fa0e0c9c3fc46734c7c35b3ce90b"
  tree = repo.lookup_tree(oid)

  it "read tree data" do
    tree.size.should eq(3)
    tree.size_recursive.should eq(6)
    # tree.size_recursive(5).should eq(5)
    # tree.size_recursive(10).should eq(6)

    tree[0].oid.to_s.should eq("1385f264afb75a56a5bec74243be9b367ba4ca08")
    tree[1].oid.to_s.should eq("fa49b077972391ad58037050f2a75f74e3671e92")
  end

  it "read tree entry data" do
    bent = tree[0]
    tent = tree[2]

    bent.name.should eq("README")
    bent.type.should eq(Git::OType::BLOB)

    tent.name.should eq("subdir")
    tent.type.should eq(Git::OType::TREE)
    tent.oid.to_s.should eq("619f9935957e010c419cb9d15621916ddfcc0b96")
    # assert_equal :tree, @repo.lookup(tent[:oid]).type
  end

  it "get entry by oid" do
    bent = tree.get_entry(Git::Oid.new("1385f264afb75a56a5bec74243be9b367ba4ca08"))
    bent.name.should eq("README")
    bent.type.should eq(Git::OType::BLOB)
  end

  it "get entry by oid returns nil if no oid" do
    nada = tree.get_entry?(Git::Oid.new("1385f264afb75a56a5bec74243be9b367ba4ca07"))
    nada.should be_nil
  end

  it "tree iteration" do
    tree.should be_a(Enumerable(Git::TreeEntry))

    enum_test = tree.to_a.sort { |a, b| a.oid <=> b.oid }.map { |e| e.name }.join(':')
    enum_test.should eq("README:subdir:new.txt")
  end

  it "tree walk only trees" do
    tree.walk_trees do |root, entry|
      entry.type.should eq(Git::OType::TREE)
    end
  end

  it "tree walk only blobs" do
    tree.walk_blobs do |root, entry|
      entry.type.should eq(Git::OType::BLOB)
    end
  end

  it "iterate subtrees" do
    tree.each_tree do |tree|
      tree.type.should eq(Git::OType::TREE)
    end
  end

  it "iterate subtree blobs" do
    tree.each_blob do |tree|
      tree.type.should eq(Git::OType::BLOB)
    end
  end
end
