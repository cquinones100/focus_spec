require "./spec_helper"

struct Dummy
  def test : Int32
    1
  end
end

describe "Dummy" do
  context "skipping a test" do
    pending "runs test" do
      Dummy.new.test.should eq 1
    end
  end
end
