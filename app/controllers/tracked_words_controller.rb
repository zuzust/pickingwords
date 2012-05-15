class TrackedWordsController < ApplicationController
  respond_to :html, :json

  # GET /tracked_words
  # GET /tracked_words.json
  def index
    @tracked_words = TrackedWord.by_asc_name
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
    respond_with(@tracked_word)
  end

  # POST /tracked_words
  # POST /tracked_words.json
  def create
    @tracked_word = TrackedWord.new(params[:tracked_word])
    flash[:notice] = 'Tracked word was successfully created.' if @tracked_word.save
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
