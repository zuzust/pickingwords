require 'spec_helper'

describe PickedWord do

  def valid_attributes
    {
      from_lang: "en",
      name: "word",
      to_lang: "ca",
      translation: "paraula",
      fav: false,
      contexts_attributes:
      [{
        sentence: "this word is written in english",
        translation: "aquesta paraula esta escrita en catala"
      }]
    }
  end

  it "should create a new instance given valid attributes" do
    tracked = Fabricate(:tracked_word, name: valid_attributes[:name])
    picked = tracked.picks.create! valid_attributes
  end
  
  it "should require the locale from which it is translated" do
    no_from_lang_picked = PickedWord.new(valid_attributes.merge(from_lang: ""))
    no_from_lang_picked.should_not be_valid
  end
  
  it "should require a name" do
    no_name_picked = PickedWord.new(valid_attributes.merge(name: ""))
    no_name_picked.should_not be_valid
  end
  
  it "should require the locale to which it is translated" do
    no_to_lang_picked = PickedWord.new(valid_attributes.merge(to_lang: ""))
    no_to_lang_picked.should_not be_valid
  end
  
  it "should require a translation" do
    no_translation_picked = PickedWord.new(valid_attributes.merge(translation: ""))
    no_translation_picked.should_not be_valid
  end

  it "should require the related tracked word" do
    no_tracked_picked = PickedWord.new valid_attributes
    no_tracked_picked.should_not be_valid
  end

  it "should require validation of related word contexts" do
    no_valid_ctxt_picked = PickedWord.new(valid_attributes.merge(contexts_attributes: [{sentence: "", translation: ""}]))
    no_valid_ctxt_picked.should_not be_valid
  end

  describe "search" do
    def params
      valid_attributes
    end

    describe "of matching name word" do
      before(:each) { @picked = Fabricate(:picked_word, valid_attributes) }

      it "should return the existing picked word" do
        matched = PickedWord.search(params[:name], params[:from_lang], params[:to_lang])
        matched.id.should == @picked.id
      end

      it "should increment existing picked word searches counter by 1" do
        matched = PickedWord.search(params[:name], params[:from_lang], params[:to_lang])
        matched.searches.should == @picked.searches + 1
      end

      it "should increment related tracked word searches counter by 1" do
        expect {
          matched = PickedWord.search(params[:name], params[:from_lang], params[:to_lang])
          matched.should eql(@picked)
        }.to change { @picked.tracked.searches }.by(1)
      end
    end

    describe "of non-matching name word" do
      it "should return nil" do
        not_matched = PickedWord.search("unmatched", params[:from_lang], params[:to_lang])
        not_matched.should be_nil
      end
    end
  end

end
