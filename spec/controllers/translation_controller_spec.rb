require 'spec_helper'

describe TranslationController do

  before(:each) do
    @user = Fabricate(:user)
    sign_in @user
  end

  let(:scope) {{ user_id: @user }}
  
  describe "translating" do
    describe "with invalid params" do
      let(:params)  { scope.merge({ name: "", ctxt: "" })}
      before(:each) { get :translate, params }
      specify { response.should redirect_to(user_picked_words_path(@user, locale: I18n.locale)) }
    end

    describe "with valid params" do
      let(:data)   {{ name: "word", from: "en", to: "ca", ctxt: "this is a word in English" }}
      let(:params) { scope.merge data }
      let(:tf)     { TranslationForm.new(data) }
      let(:fake_translation) { mock(:picked_word) }
      let(:fake_result)      { [fake_translation, 10] }

      it "should call the library method that performs the translation" do
        Translator.should_receive(:translate).with(tf.name, tf.from, tf.to, tf.ctxt).and_return(fake_result)
        get :translate, params
      end

      describe "when translation service not responding" do
        before(:each) do
          Translator.stub(:translate).and_raise(Translator::ServiceProviderError)
          get :translate, params
        end

        specify { response.should redirect_to(user_picked_words_path(@user, locale: I18n.locale)) }
      end

      describe "after valid translation" do
        before(:each) do
          Translator.stub(:translate).and_return(fake_result)
          get :translate, params
        end

        specify { assigns(:picked_word).should == fake_translation }
        specify { response.should have_rendered('picked_words/new') }
      end

      it "should update user trans_chars counter" do
        Translator.stub(:translate).and_return([fake_translation, 10])
        expect {
          get :translate, params
        }.to change{ @user.reload.trans_chars }.by(10)
      end
    end
  end

end
