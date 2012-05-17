require 'spec_helper'

describe PickedWordObserver do

  def valid_attributes
    { from_lang: I18n.default_locale, name: "word", to_lang: "ca", translation: "paraula", fav: false }
  end

  before(:each) do
    @picked = Fabricate(:picked_word, valid_attributes)
  end

  describe "before save" do
    describe "of faved picked word" do
      it "should increment related tracked word favs counter by 1" do
        expect {
          @picked.update_attribute(:fav, true)
        }.to change { @picked.tracked.favs }.by(1)
      end
    end

    describe "of unfaved picked word" do
      it "should decrement related tracked word favs counter by 1" do
        picked = Fabricate(:picked_word, valid_attributes.merge(fav: true))
        expect {
          picked.update_attribute(:fav, false)
        }.to change { picked.tracked.favs }.by(-1)
      end
    end
  end

  describe "after destroy" do
    describe "of faved picked word" do
      it "should decrement related tracked word favs counter by 1" do
        picked = Fabricate(:picked_word, valid_attributes.merge(fav: true))
        expect {
          picked.destroy
        }.to change { picked.tracked.favs }.by(-1)
      end
    end
  end
end
