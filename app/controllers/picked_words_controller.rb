class PickedWordsController < ApplicationController
  respond_to :html, :json
  before_filter :authenticate_user!
  before_filter :format_params, only: [:create, :update]
  load_and_authorize_resource

  # GET /users/:user_id/picked_words
  # GET /users/:user_id/picked_words.json
  def index
    @picked_words = @picked_words.localized_in(locale_filter)
    @picked_words = @picked_words.beginning_with(letter_filter) if letter_filter
    respond_with(current_user, @picked_words)
  end

  # GET /users/:user_id/picked_words/1
  # GET /users/:user_id/picked_words/1.json
  def show
    respond_with(current_user, @picked_word)
  end

  # GET /users/:user_id/picked_words/1/edit
  def edit
    respond_with(current_user, @picked_word)
  end

  # POST /users/:user_id/picked_words
  # POST /users/:user_id/picked_words.json
  def create
    @picked_word.tracked = TrackedWord.find(params[:picked_word][:tracked_id])
    flash[:notice] = 'Picked word was successfully created.' if @picked_word.save
    respond_with(current_user, @picked_word)
  end

  # PUT /users/:user_id/picked_words/1
  # PUT /users/:user_id/picked_words/1.json
  def update
    flash[:notice] = 'Picked word was successfully updated.' if @picked_word.update_attributes(params[:picked_word])
    respond_with(current_user, @picked_word)
  end

  # DELETE /users/:user_id/picked_words/1
  # DELETE /users/:user_id/picked_words/1.json
  def destroy
    @picked_word.destroy
    respond_with(current_user, @picked_word)
  end

  private

  def format_params
    params[:picked_word][:contexts_attributes] ||= {}
    params[:picked_word].merge!(contexts_attributes: params[:picked_word][:contexts_attributes].values)
  end

  def locale_filter
    if params[:locale]
      session[:locale_filter] = params[:locale]
      session[:letter_filter] = nil
    end

    session[:locale_filter] ||= I18n.locale
  end

  def letter_filter
    if params[:letter]
      session[:letter_filter] = params[:letter] == '@' ? nil : params[:letter]
    end

    session[:letter_filter]
  end

end
