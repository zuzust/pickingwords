class TrackedWordsController < ApplicationController
  # GET /tracked_words
  # GET /tracked_words.json
  def index
    @tracked_words = TrackedWord.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tracked_words }
    end
  end

  # GET /tracked_words/1
  # GET /tracked_words/1.json
  def show
    @tracked_word = TrackedWord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tracked_word }
    end
  end

  # GET /tracked_words/new
  # GET /tracked_words/new.json
  def new
    @tracked_word = TrackedWord.new
    @tracked_word.build_word

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tracked_word }
    end
  end

  # GET /tracked_words/1/edit
  def edit
    @tracked_word = TrackedWord.find(params[:id])
  end

  # POST /tracked_words
  # POST /tracked_words.json
  def create
    @tracked_word = TrackedWord.new(params[:tracked_word])

    respond_to do |format|
      if @tracked_word.save
        format.html { redirect_to @tracked_word, notice: 'Tracked word was successfully created.' }
        format.json { render json: @tracked_word, status: :created, location: @tracked_word }
      else
        format.html { render action: "new" }
        format.json { render json: @tracked_word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tracked_words/1
  # PUT /tracked_words/1.json
  def update
    @tracked_word = TrackedWord.find(params[:id])

    respond_to do |format|
      if @tracked_word.update_attributes(params[:tracked_word])
        format.html { redirect_to @tracked_word, notice: 'Tracked word was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tracked_word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracked_words/1
  # DELETE /tracked_words/1.json
  def destroy
    @tracked_word = TrackedWord.find(params[:id])
    @tracked_word.destroy

    respond_to do |format|
      format.html { redirect_to tracked_words_url }
      format.json { head :no_content }
    end
  end
end
