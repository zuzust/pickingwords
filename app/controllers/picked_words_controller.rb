class PickedWordsController < ApplicationController
  respond_to :html, :json

  before_filter :authenticate_user!
  before_filter :format_params, only: [:create, :update]
  before_filter :manage_session_filters, only: :index
  load_and_authorize_resource

  after_filter :expire_cached_content, only: [:create, :update, :destroy]

  # GET /users/:user_id/picked_words
  # GET /users/:user_id/picked_words.json
  def index
    @picked_words = @picked_words.localized_in(locale).beginning_with(letter)
    respond_with(user, @picked_words)
  end

  # GET /users/:user_id/picked_words/1
  # GET /users/:user_id/picked_words/1.json
  def show
    respond_with(user, @picked_word)
  end

  # GET /users/:user_id/picked_words/1/edit
  def edit
    respond_with(user, @picked_word)
  end

  # POST /users/:user_id/picked_words
  # POST /users/:user_id/picked_words.json
  def create
    @picked_word.tracked = TrackedWord.find(params[:picked_word][:tracked_id])
    flash[:notice] = 'Picked word was successfully created.' if @picked_word.save
    respond_with(user, @picked_word)
  end

  # PUT /users/:user_id/picked_words/1
  # PUT /users/:user_id/picked_words/1.json
  def update
    flash[:notice] = 'Picked word was successfully updated.' if @picked_word.update_attributes(params[:picked_word])
    respond_with(user, @picked_word)
  end

  # DELETE /users/:user_id/picked_words/1
  # DELETE /users/:user_id/picked_words/1.json
  def destroy
    @picked_word.destroy
    respond_with(user, @picked_word)
  end

  protected

  def format_params
    params[:picked_word][:contexts_attributes] ||= {}
    params[:picked_word].merge!(contexts_attributes: params[:picked_word][:contexts_attributes].values)
  end

  def manage_session_filters
    locale_filter = params[:locale]
    letter_filter = params[:letter]

    session[:locale_filter] ||= I18n.locale

    if locale_filter
      session[:locale_filter] = locale_filter
      session[:letter_filter] = nil
    end

    if letter_filter
      session[:letter_filter] = letter_filter == '@' ? nil : letter_filter
    end

    return true
  end

  def expire_cached_content
    expire_fragment(fragment: "#{locale}_#{letter}_picks")
    expire_fragment(fragment: "#{@picked_word.id}")
  end

  public

  def locale
    session[:locale_filter]
  end

  def letter
    session[:letter_filter]
  end

  helper_method :locale, :letter

end
