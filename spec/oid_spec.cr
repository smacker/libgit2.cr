require "./spec_helper"

describe Git::Oid do
  it "should accept sha" do
    oid = Git::Oid.new("5ccbec666ed9eea63f043d8e4c59a57f7d18c996")
    oid.should_not be_nil
  end

  it "should fail on incorrect sha" do
    expect_raises(Git::Error) do
      Git::Oid.new("it-is-no-a-sha")
    end
  end
end
