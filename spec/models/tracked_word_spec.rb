require 'spec_helper'

describe TrackedWord do

  def valid_attributes
    { word_attributes: { name: "word" } }
  end
  
  it "should create a new instance given valid attributes" do
    tracked = TrackedWord.create! valid_attributes
    tracked.name.should == "word"
  end
  
  describe "word" do

    def translations
      { en: "word", ca: "paraula", es: "palabra" }
    end

    let(:tracked) { Fabricate(:tracked_word, valid_attributes) }

    it "should be required" do
      no_word = TrackedWord.new
      no_word.should_not be_valid
    end
    
    it "should accept localized translations" do
      tracked.localize("ca", translations[:ca])
      tracked.localize("es", translations[:es])
      
      I18n.locale = :ca
      tracked.name.should == translations[:ca]
      
      I18n.locale = :es
      tracked.name.should == translations[:es]
    end

    it "should provide localized translations" do
      tracked.localize("ca", translations[:ca])
      tracked.localize("es", translations[:es])
      
      tracked.translate("ca").should == translations[:ca]
      tracked.translate("es").should == translations[:es]
    end

  end

end
