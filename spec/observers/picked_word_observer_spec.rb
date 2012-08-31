require 'spec_helper'

describe PickedWordObserver do

  def attrs
    { name: "word", translation: "paraula", from_lang: "en", to_lang: "ca" }
  end
  
  before(:each) do
    @user    = Fabricate(:user)
    @tracked = Fabricate(:tracked_word, name: attrs[:name])
  end

  shared_examples_for "updating related favs counters" do
    it { expect{ picked.save }.to change{ picked.tracked.reload.favs }.by(inc) }
    it { expect{ picked.save }.to change{ picked.user.reload.favs }.by(inc) }
  end

  describe "before creation" do
    describe "of faved picked word" do
      before(:each) { @picked = Fabricate.build(:picked_word, attrs.merge(fav: true, user: @user, tracked: @tracked)) }
      let(:picked) { @picked }
      let(:inc)    { 1 }
      
      it_should_behave_like "updating related favs counters"
    end
  end

  describe "before update" do
    describe "of faved picked word" do
      before(:each) do
        @picked = Fabricate(:picked_word, attrs.merge(fav: false, user: @user, tracked: @tracked))
        @picked.fav = true
      end
      let(:picked) { @picked }
      let(:inc)    { 1 }
      
      it_should_behave_like "updating related favs counters"
    end

    describe "of unfaved picked word" do
      before do
        @picked = Fabricate(:picked_word, attrs.merge(fav: true, user: @user, tracked: @tracked))
        @picked.fav = false
      end
      let(:picked) { @picked }
      let(:inc)    { -1 }
      
      it_should_behave_like "updating related favs counters"
    end

    describe "of searched picked word" do
      before do
        @picked = Fabricate(:picked_word, attrs.merge(fav: false, user: @user, tracked: @tracked))
        @picked.searches = @picked.searches + 1
      end

      it { expect{ @picked.save }.to change{ @picked.tracked.reload.searches }.by(1) }
      it { expect{ @picked.save }.to change{ @picked.user.reload.searches }.by(1) }
    end
  end

  describe "before destroy" do
    describe "of faved picked word" do
      before { @picked = Fabricate(:picked_word, attrs.merge(fav: true, user: @user, tracked: @tracked)) }

      it { expect{ @picked.destroy }.to change{ @picked.tracked.reload.favs }.by(-1) }
      it { expect{ @picked.destroy }.to change{ @picked.user.reload.favs }.by(-1) }
    end
  end
end
