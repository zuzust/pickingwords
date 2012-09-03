require 'spec_helper'

describe TrackedWord do

  def attrs
    { name: "word" }
  end

  def translations
    { "en" => "word", "ca" => "paraula", "es" => "palabra" }
  end

  before(:each) { @tracked = Fabricate(:tracked_word, attrs) }
  
  it "should create a new instance given valid attributes" do
    TrackedWord.create! attrs
  end

  describe "name" do
    it "should be required" do
      no_name_tracked = Fabricate.build(:tracked_word, attrs.merge(name: ""))
      no_name_tracked.should_not be_valid
    end
    
    it "should accept localized translations" do
      @tracked.localize("ca", translations["ca"])
      @tracked.localize("es", translations["es"])
      @tracked.save
      
      @tracked.name_translations["ca"].should == translations["ca"]
      @tracked.name_translations["es"].should == translations["es"]
    end

    it "should provide localized translations" do
      @tracked.name_translations = translations
      @tracked.save
      
      @tracked.translate("ca").should == translations["ca"]
      @tracked.translate("es").should == translations["es"]
    end
  end

  describe "search" do
    let(:args) { attrs.merge(from: I18n.default_locale) }

    describe "of matching name word" do
      it "should return the existing tracked word" do
        matched = TrackedWord.search(args[:name], args[:from])
        matched.id.should == @tracked.id
      end
    end

    describe "of non-matching name word" do
      it "should return nil" do
        not_matched = TrackedWord.search("not_matched", args[:from])
        not_matched.should be_nil
      end
    end
  end

end
