require 'spec_helper'

describe TranslationController do

  def valid_session
    {}
  end

  def params
    { from_lang: "en", name: "word", to_lang: "ca", translation: "paraula" }
  end

  describe "POST translate" do
    describe "with invalid params" do
      it "redirects to the picked words page" do
        post :translate, {:translation_form => params.merge(name: "")}, valid_session
        response.should redirect_to(picked_words_url)
      end
    end

    describe "with valid params" do
      describe "of existing picked word" do
        before(:each) do
          @tracked = TrackedWord.new
          @tracked.localize(params[:from_lang], params[:name])
          @tracked.localize(params[:to_lang], params[:translation])
          @tracked.save

          @picked = @tracked.picks.create!(from_lang: params[:from_lang], name: params[:name],
                                           to_lang: params[:to_lang], translation: params[:translation])
        end

        it "assigns the requested picked word as @picked" do
          post :translate, {:translation_form => params}, valid_session
          assigns(:picked_word).should eq(@picked)
        end

        it "increments searches counter by 1" do
          expect {
            post :translate, {:translation_form => params}, valid_session
          }.to change { @picked.reload.searches }.by(1)
        end

        it "increments related tracked word searches counter by 1" do
          expect {
            post :translate, {:translation_form => params}, valid_session
          }.to change { @tracked.reload.searches }.by(1)
        end

        it "renders the 'show' template" do
          post :translate, {:translation_form => params}, valid_session
          response.should render_template("picked_words/show")
        end
      end

      describe "of non-existing picked word" do
        before(:each) do
          PickedWord.should_receive(:search).and_return(nil)

          @tracked = TrackedWord.new
          @tracked.localize(params[:from_lang], params[:name])
          @tracked.save
        end

        describe "updates existing tracked word" do
          it "incrementing searches counter by 1" do
            expect {
              post :translate, {:translation_form => params}, valid_session
            }.to change { @tracked.reload.searches }.by(1)
          end

          it "localizing to requested locale" do
            TrackedWord.should_receive(:search).and_return(@tracked)
            post :translate, {:translation_form => params}, valid_session
            @tracked.reload.translate(params[:to_lang]).should == params[:translation]
          end
        end

        describe "creates a new tracked word" do
          before(:each) { TrackedWord.should_receive(:search).and_return(nil) }

          it "localized to passed in locales" do
            expect {
              post :translate, {:translation_form => params}, valid_session

              tracked = TrackedWord.unscoped.last
              tracked.translate(params[:from_lang]).should == params[:name]
              tracked.translate(params[:to_lang]).should == params[:translation]
            }.to change(TrackedWord, :count).by(1)
          end
        end

        it "assigns a newly created but unsaved picked_word as @picked_word" do
          TrackedWord.should_receive(:update_or_create).and_return(@tracked)
          post :translate, {:translation_form => params}, valid_session
          assigns(:picked_word).should be_a_new(PickedWord)
        end

        it "renders the 'new' template" do
          TrackedWord.should_receive(:update_or_create).and_return(@tracked)
          post :translate, {:translation_form => params}, valid_session
          response.should render_template("picked_words/new")
        end
      end
    end
  end

end
