require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe PickedWordsController do
  
  def valid_attributes
    {
      "from_lang" => "en",
      "name" => "word",
      "to_lang" => "ca",
      "translation" => "paraula",
      "fav" => "0",
      "contexts_attributes" => {
        "0" => {
          sentence: "this word is written in english",
          translation: "aquesta paraula esta escrita en catala"
        }
      }
    }
  end

  before(:each) do
    @user = Fabricate(:user)
    sign_in @user

    @tracked = TrackedWord.new
    @tracked.localize("en", "word")
    @tracked.localize("ca", "paraula")
    @tracked.save

    @picked = @user.picks.build(valid_attributes)
    @picked.tracked = @tracked
    @picked.save
  end

  describe "GET index" do
    it "assigns all picked_words as @picked_words" do
      get :index, { locale: @picked.from_lang }
      assigns(:picked_words).should eq([@picked])
    end
  end

  describe "GET show" do
    it "assigns the requested picked_word as @picked_word" do
      get :show, {:id => @picked.to_param}
      assigns(:picked_word).should eq(@picked)
    end
  end

  describe "GET edit" do
    it "assigns the requested picked_word as @picked_word" do
      get :edit, {:id => @picked.to_param}
      assigns(:picked_word).should eq(@picked)
    end
  end

  describe "POST create" do
    def create_valid_params
      valid_attributes.merge({ "tracked_id" => @tracked.to_param })
    end
    
    def create_invalid_params
      { "tracked_id" => @tracked.to_param, "from_lang" => "", "name" => "", "to_lang" => "", "translation" => "", "fav" => "0" }
    end

    describe "with valid params" do
      it "creates a new PickedWord" do
        expect {
          post :create, {:picked_word => create_valid_params}
        }.to change(PickedWord, :count).by(1)
      end

      it "increments related User picks by 1" do
        expect {
          post :create, {:picked_word => create_valid_params}
        }.to change { @user.reload.picked }.by(1)
      end

      it "increments related TrackedWord picks by 1" do
        expect {
          post :create, {:picked_word => create_valid_params}
        }.to change { @tracked.reload.picked }.by(1)
      end

      it "assigns a newly created picked_word as @picked_word" do
        post :create, {:picked_word => create_valid_params}
        assigns(:picked_word).should be_a(PickedWord)
        assigns(:picked_word).should be_persisted
      end

      it "redirects to the created picked_word" do
        post :create, {:picked_word => create_valid_params}
        response.should redirect_to([@user, PickedWord.unscoped.last])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved picked_word as @picked_word" do
        # Trigger the behavior that occurs when invalid params are submitted
        post :create, {:picked_word => create_invalid_params}
        assigns(:picked_word).should be_a_new(PickedWord)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        post :create, {:picked_word => create_invalid_params}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    def update_valid_params
      {"translation" => "updated"}
    end

    def update_invalid_params
      {"translation" => ""}
    end

    describe "with valid params" do
      it "updates the requested picked_word" do
        # This specifies that the PickedWord
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        PickedWord.any_instance.should_receive(:update_attributes).with({"translation" => "updated", "contexts_attributes" => []})
        put :update, {:id => @picked.to_param, :picked_word => update_valid_params}
      end

      it "assigns the requested picked_word as @picked_word" do
        put :update, {:id => @picked.to_param, :picked_word => update_valid_params}
        assigns(:picked_word).should eq(@picked)
      end

      it "redirects to the picked_word" do
        put :update, {:id => @picked.to_param, :picked_word => update_valid_params}
        response.should redirect_to([@user, @picked])
      end
    end

    describe "with invalid params" do
      it "assigns the picked_word as @picked_word" do
        # Trigger the behavior that occurs when invalid params are submitted
        put :update, {:id => @picked.to_param, :picked_word => update_invalid_params}
        assigns(:picked_word).should eq(@picked)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        put :update, {:id => @picked.to_param, :picked_word => update_invalid_params}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested picked_word" do
      expect {
        delete :destroy, {:id => @picked.to_param}
      }.to change(PickedWord, :count).by(-1)
    end

    it "decrements related User picks by 1" do
      expect {
        delete :destroy, {:id => @picked.to_param}
      }.to change { @user.reload.picked }.by(-1)
    end

    it "decrements related TrackedWord picks by 1" do
      expect {
        delete :destroy, {:id => @picked.to_param}
      }.to change { @tracked.reload.picked }.by(-1)
    end

    it "redirects to the picked_words list" do
      delete :destroy, {:id => @picked.to_param}
      response.should redirect_to(user_picked_words_url(@user))
    end
  end

  describe "searching" do
    describe "with invalid params" do
      before(:each) { get :search, { name: "" } }
      it { response.should redirect_to(user_picked_words_path(@user, locale: I18n.locale)) }
    end

    describe "with valid params" do
      let(:fake_results) { [mock(:picked_word, name: "word")] }

      shared_examples_for "returning search results" do
        it { response.should render_template(:index) }
        it { assigns(:picked_words).should == results }
      end

      it "should look for word among user picks" do
        controller.should_receive(:search_matching_picks).with(@user.picks, "word", "en", "ca").and_return(fake_results)
        get :search, { name: "word", from: "en", to: "ca" }
      end

      describe "for picked word" do
        let(:results) { fake_results }
        before(:each) do
          controller.stub(:search_matching_picks).and_return(results)
          get :search, { name: "word" }
        end

        it_should_behave_like "returning search results"
      end

      describe "for not picked word" do
        let(:params)  {{ name: "not picked", from: "en", to: "ca" }}
        let(:results) { [] }
        before(:each) { controller.stub(:search_matching_picks).and_return(results) }

        context "with blank source or target locale" do
          before(:each) { get :search, params.merge(to: "") }
          it_should_behave_like "returning search results"
        end

        context "with non blank source and target locales" do
          before(:each) { get :search, params }
          it { response.should redirect_to(user_translate_path(@user, params)) }
        end
      end
    end
  end
end
