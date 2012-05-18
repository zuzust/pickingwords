require 'spec_helper'

describe TranslationForm do

  def valid_attributes
    {
      from_lang: "en",
      name: "word",
      to_lang: "ca"
    }
  end
  
  it "should require the locale from which it is translated" do
    no_from_lang_form = TranslationForm.new(valid_attributes.merge(from_lang: ""))
    no_from_lang_form.should_not be_valid
  end
  
  it "should require a name" do
    no_name_form = TranslationForm.new(valid_attributes.merge(name: ""))
    no_name_form.should_not be_valid
  end
  
  it "should require the locale to which it is translated" do
    no_to_lang_form = TranslationForm.new(valid_attributes.merge(to_lang: ""))
    no_to_lang_form.should_not be_valid
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

end
