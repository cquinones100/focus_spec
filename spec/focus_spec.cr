require "spec"
require "../src/focus_spec"

include FocusSpec

SHOULD_RUN_CONTEXT = " should run context\n"
SHOULD_RUN_DESCRIBE = " should run describe\n"
SHOULD_RUN_IT = " should run it\n"
SHOULD_NOT_RUN_CONTEXT = " should not run context\n"
SHOULD_NOT_RUN_DESCRIBE = " should not run describe\n"
SHOULD_NOT_RUN_IT = " should not run it\n"

describe "fcontext" do
  context "when focussed" do
    fcontext "something" do 
      it "runs" do
        print SHOULD_NOT_RUN_CONTEXT
        true.should eq true
      end
    end
  end

  context "when not focussed" do
    context "something else" do
      it "doesn't run" do
        print SHOULD_NOT_RUN_CONTEXT
        false.should eq true
      end
    end
  end
end

fdescribe "fdescribe" do
  it "runs" do
    print SHOULD_NOT_RUN_DESCRIBE

    true.should eq true
  end
end

describe "describe" do
  it "doesn't run" do
    print SHOULD_NOT_RUN_DESCRIBE
    
    false.should eq false
  end
end

fdescribe "fit" do
  fcontext "when focussed" do
    fit "runs" do
      print " running fit "
      true.should eq true
    end

    it "runs" do
      print " should not run it "
      false.should eq true
    end
  end

  context "something else" do
    it "doesn't run" do
      print " should not run it "
      false.should eq true
    end
  end
end
