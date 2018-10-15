require "./spec_helper"

describe Git::Tag do
  repo = FixtureRepo.from_libgit2("testrepo.git")

  it "should read a tag" do
    oid = "7b4384978d2493e851f9cca7858815fac9b10980"
    obj = repo.lookup_tag(oid)

    obj.oid.to_s.should eq(oid)
    # assert_equal :tag, obj.type
    obj.message.should eq("This is a very simple tag.\n")
    obj.name.should eq("e90810b")
    obj.target_oid.to_s.should eq("e90810b8df3e80c413d903f631643c716887138d")
    obj.target_type.should eq(Git::OType::COMMIT)
    c = obj.tagger
    c.name.should eq("Vicent Marti")
    c.name.should eq("Vicent Marti")
    c.email.should eq("tanoku@gmail.com")
  end

  it "should read the oid of a tag" do
    oid = "7b4384978d2493e851f9cca7858815fac9b10980"
    obj = repo.lookup_tag(oid)

    obj.target_oid.to_s.should eq("e90810b8df3e80c413d903f631643c716887138d")
  end

  pending "lookup" do
    tag = repo.tags["e90810b"]

    tag.name.should eq("e90810b")
    tag.canonical_name.should eq("refs/tags/e90810b")
  end

  pending "should each" do
    tags = repo.tags.to_a # .sort_by(&.name)

    tags.size.should eq(7)
    tags[0].name.should eq("annotated_tag_to_blob")
    tags[1].name.should eq("e90810b")
  end
end
