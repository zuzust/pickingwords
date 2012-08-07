require 'spec_helper'

describe TranslationForm do

  def valid_attributes
    {
      from_lang: "en",
      name: "word",
      ctx_sentence: "This word is written in english",
      to_lang: "ca"
    }
  end
  
  it "should require a name" do
    no_name_form = TranslationForm.new(valid_attributes.merge(name: ""))
    no_name_form.should_not be_valid
  end
  
  it "should require a well formed name" do
    bad_name_form = TranslationForm.new(valid_attributes.merge(name: "666"))
    bad_name_form.should_not be_valid
  end

  it "should remove name trailing whitespaces before validation" do
    form = TranslationForm.new(valid_attributes.merge(name: "  word "))
    form.should be_valid
    form.name.should == "word"
  end

  it "should downcase the name before validation" do
    form = TranslationForm.new(valid_attributes.merge(name: "Word"))
    form.should be_valid
    form.name.should == "word"
  end

  it "should remove context sentence trailing whitespaces before validation" do
    form = TranslationForm.new(valid_attributes.merge(ctx_sentence: "  This    is the context "))
    form.should be_valid
    form.ctx_sentence.should == "This is the context"
  end

end
