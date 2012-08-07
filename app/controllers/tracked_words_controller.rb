class TrackedWordsController < ApplicationController
  respond_to :html, :json

  before_filter :authenticate_admin!
  load_and_authorize_resource

  def index
    @tracked_words = @tracked_words.by_asc_name.paginate(:page => params[:page])
  end

  def destroy
    respond_with(@tracked_word) do |format|
      flash[:alert] = @tracked_word.errors[:base].to_sentence if !@tracked_word.destroy
      format.html { redirect_to tracked_words_url }
    end
  end
end
