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

  let(:user) { Fabricate(:user) }
  let(:tracked) { Fabricate(:tracked_word, name: valid_attributes[:name]) }

  it "should create a new instance given valid attributes" do
    picked = PickedWord.new(valid_attributes)
    picked.user = user
    picked.tracked = tracked
    picked.save
  end
  
  it "should require the locale from which it is translated" do
    no_from_lang_picked = PickedWord.new(valid_attributes.merge(from_lang: ""))
    no_from_lang_picked.user = user
    no_from_lang_picked.tracked = tracked
    no_from_lang_picked.should_not be_valid
  end
  
  it "should require a name" do
    no_name_picked = PickedWord.new(valid_attributes.merge(name: ""))
    no_name_picked.user = user
    no_name_picked.tracked = tracked
    no_name_picked.should_not be_valid
  end
  
  it "should require the locale to which it is translated" do
    no_to_lang_picked = PickedWord.new(valid_attributes.merge(to_lang: ""))
    no_to_lang_picked.user = user
    no_to_lang_picked.tracked = tracked
    no_to_lang_picked.should_not be_valid
  end
  
  it "should require a translation" do
    no_translation_picked = PickedWord.new(valid_attributes.merge(translation: ""))
    no_translation_picked.user = user
    no_translation_picked.tracked = tracked
    no_translation_picked.should_not be_valid
  end

  it "should require the related user profile" do
    no_tracked_picked = PickedWord.new valid_attributes
    no_tracked_picked.tracked = tracked
    no_tracked_picked.should_not be_valid
  end

  it "should require the related tracked word" do
    no_tracked_picked = PickedWord.new valid_attributes
    no_tracked_picked.user = user
    no_tracked_picked.should_not be_valid
  end

  it "should require validation of related word contexts" do
    no_valid_ctxt_picked = PickedWord.new(valid_attributes.merge(contexts_attributes: [{sentence: "not all_blank", translation: ""}]))
    no_valid_ctxt_picked.user = user
    no_valid_ctxt_picked.tracked = tracked
    no_valid_ctxt_picked.should_not be_valid
  end

end
