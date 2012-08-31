require 'spec_helper'

describe TrackedWord do

  def valid_attributes
    { name: "word" }
  end

  def translations
    { "en" => "word", "ca" => "paraula", "es" => "palabra" }
  end

  before(:each) { @tracked = Fabricate(:tracked_word, valid_attributes) }
  
  it "should create a new instance given valid attributes" do
    TrackedWord.create! valid_attributes
  end

  describe "name" do
    it "should be required" do
      no_name_tracked = Fabricate.build(:tracked_word, valid_attributes.merge(name: ""))
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
    def params
      valid_attributes.merge(from_lang: I18n.default_locale)
    end

    describe "of matching name word" do
      it "should return the existing tracked word" do
        matched = TrackedWord.search(params[:name], params[:from_lang])
        matched.id.should == @tracked.id
      end
    end

    describe "of non-matching name word" do
      it "should return nil" do
        not_matched = TrackedWord.search("not_matched", params[:from_lang])
        not_matched.should be_nil
      end
    end
  end

  describe "update_or_create" do
    def params
      { from_lang: "en", name: "word", to_lang: "ca", translation: "paraula" }
    end

    describe "of matching name word" do
      it "should localize the tracked word to translation lang if not localized yet" do
        TrackedWord.should_receive(:search).and_return(@tracked)
        matched = TrackedWord.update_or_create(params[:from_lang], params[:name],
                                               params[:to_lang],   params[:translation])

        matched.translate(params[:to_lang]).should == params[:translation]
      end

      it "should not localize the tracked word to translation lang if already localized" do
        @tracked.name_translations = translations
        @tracked.save

        TrackedWord.should_receive(:search).and_return(@tracked)
        matched = TrackedWord.update_or_create(params[:from_lang], params[:name],
                                               params[:to_lang],   "alt_translation")

        matched.translate(params[:to_lang]).should_not == "alt_translation"
        matched.translate(params[:to_lang]).should == @tracked.translate(params[:to_lang])
      end
    end

    describe "of non-matching name word" do
      it "should create a new tracked word" do
        TrackedWord.should_receive(:search).and_return(nil)
        expect {
          TrackedWord.update_or_create(params[:from_lang], params[:name],
                                       params[:to_lang],   params[:translation])
        }.to change(TrackedWord, :count).by(1)
      end

      it "should localize the new tracked word to origin and destination langs" do
        TrackedWord.should_receive(:search).and_return(nil)
        not_matched = TrackedWord.update_or_create(params[:from_lang], params[:name],
                                                   params[:to_lang],   params[:translation])

        not_matched.translate(params[:from_lang]).should == params[:name]
        not_matched.translate(params[:to_lang]).should == params[:translation]
      end
    end
  end

end
