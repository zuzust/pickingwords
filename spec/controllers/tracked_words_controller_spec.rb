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

describe TrackedWordsController do

  # This should return the minimal set of attributes required to create a valid
  # TrackedWord. As you add validations to TrackedWord, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { name: "word" }
  end

  before(:each) do
    @user = Fabricate(:user)
    sign_in @user

    @tracked = Fabricate(:tracked_word, valid_attributes)
  end

  describe "GET index" do
    it "assigns all tracked_words as @tracked_words" do
      get :index, {}
      assigns(:tracked_words).should eq([@tracked])
    end
  end

  describe "GET show" do
    it "assigns the requested tracked_word as @tracked_word" do
      get :show, {:id => @tracked.to_param}
      assigns(:tracked_word).should eq(@tracked)
    end
  end

  describe "DELETE destroy" do
    describe "with no picks associated" do
      it "destroys the requested tracked_word" do
        expect {
          delete :destroy, {:id => @tracked.to_param}
        }.to change(TrackedWord, :count).by(-1)
      end

      it "redirects to the tracked_words list" do
        delete :destroy, {:id => @tracked.to_param}
        response.should redirect_to(tracked_words_url)
      end
    end

    describe "with associated picks" do
      it "should not destroy the requested tracked_word" do
        expect {
          TrackedWord.any_instance.stub(:destroy).and_return(false)
          delete :destroy, {:id => @tracked.to_param}
        }.to change(TrackedWord, :count).by(0)
      end
    end
  end

end
