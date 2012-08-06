class PickedWordsController < ApplicationController
  respond_to :html, :json
  helper_method :locale, :letter

  before_filter :authenticate_user!
  before_filter :format_params, only: [:create, :update]
  before_filter :manage_session_filters, only: :index
  load_and_authorize_resource

  after_filter :expire_cached_content, only: [:create, :update, :destroy]

  caches_action :show, layout: false

  def index
    @picked_words = @picked_words.localized_in(locale).beginning_with(letter)
    respond_with(user, @picked_words)
  end

  def show
    respond_with(user, @picked_word)
  end

  def edit
  end

  def create
    @picked_word.tracked = TrackedWord.find(params[:picked_word][:tracked_id])
    flash[:notice] = 'Picked word was successfully created.' if @picked_word.save
    respond_with(user, @picked_word)
  end

  def update
    flash[:notice] = 'Picked word was successfully updated.' if @picked_word.update_attributes(params[:picked_word])
    respond_with(user, @picked_word)
  end

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

    if not locale_filter and not letter_filter
      new_params = { locale: locale }
      new_params.merge!(letter: letter) if letter

      flash.keep
      redirect_to user_picked_words_url(user, new_params)
    else
      if locale_filter
        session[:locale_filter] = locale_filter
        session[:letter_filter] = nil
      end

      session[:letter_filter] = letter_filter if letter_filter
    end

    return true
  end

  def expire_cached_content
    expire_fragment(@picked_word)
    expire_action action: :show
  end

  def locale
    session[:locale_filter] ||= I18n.locale
  end

  def letter
    session[:letter_filter]
  end

end
