require 'spec_helper'

describe TranslationController do

  before(:each) do
    @user = Fabricate(:user)
    sign_in @user
  end
  
  describe "translating" do
    describe "with invalid params" do
      before(:each) { get :translate, { name: "", ctxt: "" } }
      it { response.should redirect_to(user_picked_words_path(@user, locale: I18n.locale)) }
    end

    describe "with valid params" do
      let(:params)  {{ name: "word", from: "en", to: "ca", ctxt: "this is a word in English" }}
      let(:tf)      { TranslationForm.new(params) }
      before(:each) { @tracked = Fabricate(:tracked_word, name: tf.name) }

      it "should call the model method that performs the translation" do
        TrackedWord.should_receive(:update_or_create).with(tf.from, tf.name, tf.to, tf.translation).and_return(@tracked)
        get :translate, params
      end

      describe "after valid translation" do
        before(:each) do
          TrackedWord.stub(:update_or_create).and_return(@tracked)
          get :translate, params
        end

        it { response.should render_template('picked_words/new') }
        it { assigns(:picked_word).should be_a_new(PickedWord) }
        it { assigns(:picked_word).tracked.should == @tracked }
      end
    end
  end

end
