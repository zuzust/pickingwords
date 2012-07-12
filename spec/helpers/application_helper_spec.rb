require 'spec_helper'

describe ApplicationHelper do

  describe "full_title" do
    it "should include the page title" do
      full_title("foo").should =~ /foo/
    end

    it "should include the base title" do
      full_title("foo").should =~ /^Pickingwords/
    end

    it "should not include a bar for the home page" do
      full_title("").should_not =~ /\|/
    end
  end

  describe "emphasize" do
    let(:emphasized) { emphasize(word, sentence) }
    
    context "when applied to a single word" do
      let(:word)     { "test" }
      let(:sentence) { "this test passes" }

      it "should target just the word" do
        emphasized.should == "this <strong>test</strong> passes"
      end
    end
    
    context "when applied to a compound word" do
      let(:word)     { "back up" }
      let(:sentence) { "my wife backed me up over my decision to quit my job" }

      it "should target all the words between first and last" do
        emphasized.should == "my wife <strong>backed me up</strong> over my decision to quit my job"
      end
    end
  end

end
