require "spec"
require "../../../src/focus_spec/focus_spec"

include FocusSpec

describe "fcontext" do
  context "when focussed" do
    fcontext "something" do 
      it "runs" do
        true.should eq true
      end
    end

    fcontext "something" do
      it "runs" do
        true.should eq true
      end
    end
  end

  context "when not focussed" do
    context "something else" do
      it "doesn't run" do
        false.should eq true
      end
    end
  end
end

pending "fit" do
  context "when focussed" do
    fit "runs" do
      true.should eq true
    end

    fit "runs" do
      true.should eq true
    end
  end

  context "something else" do
    it "doesn't run" do
      false.should eq true
    end
  end
end
