require "integration_helper"

describe "empty project" do
  xit "looks like a black screen" do
    expect_looks_same(after: 1.frame)
  end
end
