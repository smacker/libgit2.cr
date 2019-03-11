require "./spec_helper"

describe Git::Object do
  repo = FixtureRepo.from_rugged("testrepo.git")

  it "read raw data" do
    obj = repo.lookup_commit("8496071c1b46c854b31185ea97743be6a8774479")
    obj.read_raw.should be_a(Git::OdbObject)
  end
end
