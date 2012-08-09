require 'spec_helper'

describe TranslationController do

  def params
    {
      name: "word",
      from: "en",
      to: "ca",
      ctxt: "this is a word in english"
    }
  end

  let(:tf) { TranslationForm.new(params) }

  before(:each) do
    @user = Fabricate(:user)
    sign_in @user
  end
  
  describe "Get translate" do
    describe "with invalid params" do
      it "redirects to the picked words page" do
        get :translate, params.merge(name: "")
        response.should redirect_to(user_picked_words_url(@user))
      end
    end

    describe "with valid params" do
      it "increments related user profile searches counter by 1" do
        expect {
          get :translate, params
        }.to change { @user.reload.searches }.by(1)
      end

      describe "of existing picked word" do
        before(:each) do
          @tracked = TrackedWord.new
          @tracked.localize(tf.from, tf.name)
          @tracked.localize(tf.to, tf.translation)
          @tracked.save

          @picked = @user.picks.build(tf.word_attributes)
          @picked.tracked = @tracked
          @picked.save
        end

        it "increments searches counter by 1" do
          expect {
            get :translate, params
          }.to change { @picked.reload.searches }.by(1)
        end

        it "increments related tracked word searches counter by 1" do
          expect {
            get :translate, params
          }.to change { @tracked.reload.searches }.by(1)
        end

        it "redirects to the picked words index template" do
          get :translate, params
          response.should redirect_to(user_picked_words_url(@user, name: tf.name, from: tf.from, to: tf.to))
        end
      end

      describe "of non-existing picked word" do
        before(:each) do
          # PickedWord.should_receive(:search).and_return(nil)

          @tracked = TrackedWord.new
          @tracked.localize(tf.from, tf.name)
          @tracked.save
        end

        describe "updates existing tracked word" do
          it "incrementing searches counter by 1" do
            expect {
              get :translate, params
            }.to change { @tracked.reload.searches }.by(1)
          end

          it "localizing to requested locale" do
            TrackedWord.should_receive(:search).and_return(@tracked)
            get :translate, params
            @tracked.reload.translate(tf.to).should == tf.translation
          end
        end

        describe "creates a new tracked word" do
          before(:each) { TrackedWord.should_receive(:search).and_return(nil) }

          it "localized to passed in locales" do
            expect {
              get :translate, params

              tracked = TrackedWord.unscoped.last
              tracked.translate(tf.from).should == tf.name
              tracked.translate(tf.to).should == tf.translation
            }.to change(TrackedWord, :count).by(1)
          end
        end

        it "assigns a newly created but unsaved picked_word as @picked_word" do
          TrackedWord.should_receive(:update_or_create).and_return(@tracked)
          get :translate, params
          assigns(:picked_word).should be_a_new(PickedWord)
        end

        it "renders the 'new' template" do
          TrackedWord.should_receive(:update_or_create).and_return(@tracked)
          get :translate, params
          response.should render_template("picked_words/new")
        end
      end
    end
  end

end
