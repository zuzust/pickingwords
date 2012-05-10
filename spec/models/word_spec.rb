require 'spec_helper'

describe Word do

  def valid_attributes
    { name: "word" }
  end

  describe "name" do

    def translations
      { en: "word", ca: "paraula", es: "palabra" }
    end

    let(:word) { Fabricate.build(:word, valid_attributes) }

    it "should be required" do
      no_name_word = Fabricate.build(:word, valid_attributes.merge(name: ""))
      no_name_word.should_not be_valid
    end

    it "should accept localized translations" do
      word.localize("ca", translations[:ca])
      word.localize("es", translations[:es])

      word.name_translations["ca"].should == translations[:ca]
      word.name_translations["es"].should == translations[:es]
    end

    it "should provide localized translations" do
      word.name_translations = { "en" => translations[:en], "ca" => translations[:ca], "es" => translations[:es] }

      word.translate("ca").should == translations[:ca]
      word.translate("es").should == translations[:es]
    end

  end
  
end
