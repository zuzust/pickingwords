class TrackedWordsController < ApplicationController
  respond_to :html, :json
  load_and_authorize_resource

  # GET /tracked_words
  # GET /tracked_words.json
  def index
    @tracked_words = @tracked_words.by_asc_name.paginate(:page => params[:page])
    respond_with(@tracked_words)
  end

  # DELETE /tracked_words/1
  # DELETE /tracked_words/1.json
  def destroy
    respond_with(@tracked_word) do |format|
      flash[:alert] = @tracked_word.errors[:base].to_sentence if !@tracked_word.destroy
      format.html { redirect_to tracked_words_url }
    end
  end
end
