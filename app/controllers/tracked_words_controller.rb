class TrackedWordsController < ApplicationController
  respond_to :html, :json

  # GET /tracked_words
  # GET /tracked_words.json
  def index
    @tracked_words = TrackedWord.by_asc_name.paginate(:page => params[:page])
    respond_with(@tracked_words)
  end

  # GET /tracked_words/1
  # GET /tracked_words/1.json
  def show
    @tracked_word = TrackedWord.find(params[:id])
    respond_with(@tracked_word)
  end

  # DELETE /tracked_words/1
  # DELETE /tracked_words/1.json
  def destroy
    @tracked_word = TrackedWord.find(params[:id])

    respond_with(@tracked_word) do |format|
      flash[:alert] = @tracked_word.errors[:base].to_sentence if !@tracked_word.destroy
      format.html { redirect_to tracked_words_url }
    end
  end
end
