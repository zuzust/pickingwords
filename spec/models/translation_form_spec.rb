require 'spec_helper'

describe TranslationForm do

  def valid_attributes
    {
      name: "word",
      from: "en",
      to: "ca",
      ctxt: "This word is written in english"
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
    form = TranslationForm.new(valid_attributes.merge(ctxt: "  This    is the context "))
    form.should be_valid
    form.ctxt.should == "This is the context"
  end

end
