require 'spec_helper'

describe TranslationController do

  def valid_session
    {}
  end

  def params
    { fl: "en", n: "word", tl: "ca", t: "paraula" }
  end

  describe "GET translate" do
    describe "of existing picked word" do
      before(:each) do
        @tracked = TrackedWord.new
        @tracked.localize(params[:fl], params[:n])
        @tracked.localize(params[:tl], params[:t])
        @tracked.save

        @picked = @tracked.picks.create!(from_lang: params[:fl], name: params[:n],
                                        to_lang: params[:tl], translation: params[:t])
      end

      it "assigns the requested picked word as @picked" do
        get :translate, {:word => params}, valid_session
        assigns(:picked_word).should eq(@picked)
      end

      it "increments searches counter by 1" do
        expect {
          get :translate, {:word => params}, valid_session
        }.to change { @picked.reload.searches }.by(1)
      end

      it "increments related tracked word searches counter by 1"

      it "renders the 'show' template" do
        get :translate, {:word => params}, valid_session
        response.should render_template("picked_words/show")
      end
    end

    describe "of non-existing picked word" do
      before(:each) do
        PickedWord.should_receive(:search).and_return(nil)

        @tracked = TrackedWord.new
        @tracked.localize(params[:fl], params[:n])
        @tracked.save
      end

      describe "updates existing tracked word" do
        it "incrementing searches counter by 1" do
          expect {
            get :translate, {:word => params}, valid_session
            assigns(:tracked).should eq(@tracked)
          }.to change { @tracked.reload.searches }.by(1)
        end

        it "localizing to requested locale" do
          TrackedWord.should_receive(:search).and_return(@tracked)
          get :translate, {:word => params}, valid_session
          @tracked.reload.translate(params[:tl]).should == params[:t]
        end
      end

      describe "creates a new tracked word" do
        before(:each) { TrackedWord.should_receive(:search).and_return(nil) }

        it "localized to passed in locales" do
          expect {
            get :translate, {:word => params}, valid_session

            tracked = TrackedWord.unscoped.last
            tracked.translate(params[:fl]).should == params[:n]
            tracked.translate(params[:tl]).should == params[:t]
          }.to change(TrackedWord, :count).by(1)
        end
      end

      it "assigns a newly created but unsaved picked_word as @picked_word" do
        TrackedWord.should_receive(:update_or_create).and_return(@tracked)
        get :translate, {:word => params}, valid_session
        assigns(:picked_word).should be_a_new(PickedWord)
      end

      it "renders the 'new' template" do
        TrackedWord.should_receive(:update_or_create).and_return(@tracked)
        get :translate, {:word => params}, valid_session
        response.should render_template("picked_words/new")
      end
    end
  end

end
