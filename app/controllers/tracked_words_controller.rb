class TrackedWordsController < ApplicationController
  respond_to :html, :json

  # GET /tracked_words
  # GET /tracked_words.json
  def index
    @tracked_words = TrackedWord.all
    respond_with(@tracked_words)
  end

  # GET /tracked_words/1
  # GET /tracked_words/1.json
  def show
    @tracked_word = TrackedWord.find(params[:id])
    respond_with(@tracked_word)
  end

  # GET /tracked_words/new
  # GET /tracked_words/new.json
  def new
    @tracked_word = TrackedWord.new
    @tracked_word.build_word
    respond_with(@tracked_word)
  end

  # GET /tracked_words/1/edit
  def edit
    @tracked_word = TrackedWord.find(params[:id])
    respond_with(@tracked_word)
  end

  # POST /tracked_words
  # POST /tracked_words.json
  def create
    @tracked_word = TrackedWord.new(params[:tracked_word])
    flash[:notice] = 'Tracked word was successfully created.' if @tracked_word.save
    respond_with(@tracked_word)
  end

  # PUT /tracked_words/1
  # PUT /tracked_words/1.json
  def update
    @tracked_word = TrackedWord.find(params[:id])
    flash[:notice] = 'Tracked word was successfully updated.' if @tracked_word.update_attributes(params[:tracked_word])
    respond_with(@tracked_word)
  end

  # DELETE /tracked_words/1
  # DELETE /tracked_words/1.json
  def destroy
    @tracked_word = TrackedWord.find(params[:id])
    @tracked_word.destroy
    respond_with(@tracked_word)
  end
end
