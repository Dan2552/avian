require "integration_helper"

describe "empty project" do
  subject { "empty" }

  it "looks like a black screen", threshold: 0 do
    is_expected.to look_correct_after(4.frames)
  end
end
