require "./spec_helper"

# Let's verify that the examples work as expected

crystal = "crystal" # path to crystal

def capture(cmd, params)
    stdout = IO::Memory.new
    stderr = IO::Memory.new
    res = Process.new(cmd, params, output: stdout, error: stderr).wait
  
    return stdout.to_s, stderr.to_s, res.exit_status / 256
  end
  
describe "examples" do
  it "log.cr" do
    output, error, exit_code = capture(crystal, ["examples/log.cr"])
    output.should eq ""
    error.should contain("Usage: log repo_path")
    exit_code.should eq(1)
  end


  it "log.cr ." do
    output, error, exit_code = capture(crystal, ["examples/log.cr", "."])
    # The first two commits in this repo
    output.should contain(<<-END)
commit ca7a996010c6f33c5fefaedf75bb63a7b9dc99a0
Author: Maxim Sukharev <maxim@sourced.tech>
Date:   2018-10-15 13:50:52 UTC

basic implementation

commit 5ccbec666ed9eea63f043d8e4c59a57f7d18c996
Author: Maxim Sukharev <maxim@sourced.tech>
Date:   2018-07-25 18:56:45 UTC

initial
END
    error.should eq ""
    exit_code.should eq(0)
  end


  it "log.cr --reverse ." do
    output, error, exit_code = capture(crystal, ["examples/log.cr", "--reverse", "."])
    # The first two commits in this repo in reversed order
    output.should contain(<<-END)
commit 5ccbec666ed9eea63f043d8e4c59a57f7d18c996
Author: Maxim Sukharev <maxim@sourced.tech>
Date:   2018-07-25 18:56:45 UTC

initial

commit ca7a996010c6f33c5fefaedf75bb63a7b9dc99a0
Author: Maxim Sukharev <maxim@sourced.tech>
Date:   2018-10-15 13:50:52 UTC

basic implementation
END
    error.should eq ""
    exit_code.should eq(0)
  end
end
