require 'spec_helper'

describe PickedWordObserver do

  def valid_attributes
    { from_lang: I18n.default_locale, name: "word", to_lang: "ca", translation: "paraula", fav: false }
  end

  before(:each) do
    @user = Fabricate(:user)
    @tracked = Fabricate(:tracked_word, name: valid_attributes[:name])
  end

  describe "before save" do
    describe "of faved picked word" do
      it "should increment related tracked word favs counter by 1" do
        picked = Fabricate(:picked_word, valid_attributes.merge(user: @user, tracked: @tracked))
        expect {
          picked.update_attribute(:fav, true)
        }.to change { picked.tracked.reload.favs }.by(1)
      end

      it "should increment related user favs counter by 1" do
        picked = Fabricate(:picked_word, valid_attributes.merge(user: @user, tracked: @tracked))
        expect {
          picked.update_attribute(:fav, true)
        }.to change { picked.user.reload.favs }.by(1)
      end
    end

    describe "of unfaved existing picked word" do
      it "should decrement related tracked word favs counter by 1" do
        picked = Fabricate(:picked_word, valid_attributes.merge(fav: true, user: @user, tracked: @tracked))
        expect {
          picked.update_attribute(:fav, false)
        }.to change { picked.tracked.reload.favs }.by(-1)
      end

      it "should decrement related user favs counter by 1" do
        picked = Fabricate(:picked_word, valid_attributes.merge(fav: true, user: @user, tracked: @tracked))
        expect {
          picked.update_attribute(:fav, false)
        }.to change { picked.user.reload.favs }.by(-1)
      end
    end

    describe "of unfaved new picked word" do
      it "should not decrement related tracked word favs counter by 1" do
        picked = Fabricate.build(:picked_word, valid_attributes.merge(user: @user, tracked: @tracked))
        expect {
          picked.save
        }.to change { picked.tracked.reload.favs }.by(0)
      end

      it "should not decrement related user favs counter by 1" do
        picked = Fabricate.build(:picked_word, valid_attributes.merge(user: @user, tracked: @tracked))
        expect {
          picked.save
        }.to change { picked.user.reload.favs }.by(0)
      end
    end
  end

  describe "before update" do
    describe "of searched picked word" do
      it "should increment related tracked word searches counter by 1" do
        picked = Fabricate(:picked_word, valid_attributes.merge(user: @user, tracked: @tracked))
        expect {
          picked.update_attribute(:searches, picked.searches + 1)
        }.to change { picked.tracked.reload.searches }.by(1)
      end
    end
  end

  describe "before destroy" do
    describe "of faved picked word" do
      it "should decrement related tracked word favs counter by 1" do
        picked = Fabricate(:picked_word, valid_attributes.merge(fav: true, user: @user, tracked: @tracked))
        expect {
          picked.destroy
        }.to change { picked.tracked.reload.favs }.by(-1)
      end

      it "should decrement related user favs counter by 1" do
        picked = Fabricate(:picked_word, valid_attributes.merge(fav: true, user: @user, tracked: @tracked))
        expect {
          picked.destroy
        }.to change { picked.user.reload.favs }.by(-1)
      end
    end
  end
end
