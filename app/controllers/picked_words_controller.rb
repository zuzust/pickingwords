class PickedWordsController < ApplicationController
  respond_to :html, :json

  # GET /picked_words
  # GET /picked_words.json
  def index
    @picked_words = PickedWord.all
    respond_with(@picked_words)
  end

  # GET /picked_words/1
  # GET /picked_words/1.json
  def show
    @picked_word = PickedWord.find(params[:id])
    respond_with(@picked_word)
  end

  # GET /picked_words/1/edit
  def edit
    @picked_word = PickedWord.find(params[:id])
    respond_with(@picked_word)
  end

  # POST /picked_words
  # POST /picked_words.json
  def create
    tracked = TrackedWord.find(params[:picked_word][:tracked_id])
    @picked_word = tracked.picks.build(params[:picked_word])
    flash[:notice] = 'Picked word was successfully created.' if @picked_word.save
    respond_with(@picked_word)
  end

  # PUT /picked_words/1
  # PUT /picked_words/1.json
  def update
    @picked_word = PickedWord.find(params[:id])
    flash[:notice] = 'Picked word was successfully updated.' if @picked_word.update_attributes(params[:picked_word])
    respond_with(@picked_word)
  end

  # DELETE /picked_words/1
  # DELETE /picked_words/1.json
  def destroy
    @picked_word = PickedWord.find(params[:id])
    @picked_word.destroy
    respond_with(@picked_word)
  end
end
