require 'spec_helper'

describe TrackedWord do

  def valid_attributes
    { name: "word" }
  end
  
  it "should create a new instance given valid attributes" do
    new_tracked = TrackedWord.create! valid_attributes
    new_tracked.name.should == "word"
  end

  describe "name" do
    def translations
      { "en" => "word", "ca" => "paraula", "es" => "palabra" }
    end

    before(:each) { @tracked = Fabricate(:tracked_word, valid_attributes) }

    it "should be required" do
      no_name_tracked = Fabricate.build(:tracked_word, valid_attributes.merge(name: ""))
      no_name_tracked.should_not be_valid
    end
    
    it "should accept localized translations" do
      @tracked.localize("ca", translations["ca"])
      @tracked.localize("es", translations["es"])
      @tracked.save
      
      I18n.locale = :ca
      @tracked.name.should == translations["ca"]
      
      I18n.locale = :es
      @tracked.name.should == translations["es"]
    end

    it "should provide localized translations" do
      @tracked.name_translations = { "en" => translations["en"], "ca" => translations["ca"], "es" => translations["es"] }
      @tracked.save
      
      @tracked.translate("ca").should == translations["ca"]
      @tracked.translate("es").should == translations["es"]
    end
  end

end
