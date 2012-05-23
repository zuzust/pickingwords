require 'spec_helper'

describe PickedWordObserver do

  def valid_attributes
    { from_lang: I18n.default_locale, name: "word", to_lang: "ca", translation: "paraula", fav: false }
  end

  describe "around save" do
    describe "of searched existing picked word" do
      it "should increment related tracked word searches counter by 1" do
        picked = Fabricate(:picked_word, valid_attributes)
        expect {
          picked.update_attribute(:searches, picked.searches + 1)
        }.to change { picked.tracked.searches }.by(1)
      end
    end

    describe "of faved picked word" do
      it "should increment related tracked word favs counter by 1" do
        picked = Fabricate(:picked_word, valid_attributes)
        expect {
          picked.update_attribute(:fav, true)
        }.to change { picked.tracked.favs }.by(1)
      end
    end

    describe "of unfaved existing picked word" do
      it "should decrement related tracked word favs counter by 1" do
        picked = Fabricate(:picked_word, valid_attributes.merge(fav: true))
        expect {
          picked.update_attribute(:fav, false)
        }.to change { picked.tracked.favs }.by(-1)
      end
    end

    describe "of unfaved new picked word" do
      it "should not decrement related tracked word favs counter by 1" do
        picked = Fabricate.build(:picked_word, valid_attributes)
        expect {
          picked.save
        }.to change { picked.tracked.favs }.by(0)
      end
    end
  end

  describe "around update" do
    describe "of searched picked word" do
      it "should increment related tracked word searches counter by 1" do
        picked = Fabricate(:picked_word, valid_attributes)
        # expect {
        #   picked.update_attribute(:searches, picked.searches + 1)
        # }.to change { picked.tracked.searches }.by(1)
        picked.tracked.searches.should == 1
        picked.update_attribute(:searches, picked.searches + 1)
        picked.tracked.searches.should == 2
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
