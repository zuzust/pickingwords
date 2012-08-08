class PickedWordsController < ApplicationController
  respond_to :html, :json
  helper_method :locale, :letter

  before_filter :authenticate_user!
  before_filter :format_request_params, only: [:create, :update]
  before_filter :manage_filters, only: :index
  load_and_authorize_resource

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

    if @picked_word.save
      expire_cached_content(@picked_word)
      store_in_session(locale_filter: @picked_word.from_lang, letter_filter: @picked_word.name.chr)
      flash[:notice] = 'Picked word was successfully created.'
    end

    respond_with(user, @picked_word)
  end

  def update
    if @picked_word.update_attributes(params[:picked_word])
      expire_cached_content(@picked_word)
      flash[:notice] = 'Picked word was successfully updated.'
    end

    respond_with(user, @picked_word)
  end

  def destroy
    @picked_word.destroy
    expire_cached_content(@picked_word)

    respond_with(user, @picked_word)
  end

private

  def format_request_params
    params[:picked_word][:contexts_attributes] ||= {}
    params[:picked_word].merge!(contexts_attributes: params[:picked_word][:contexts_attributes].values)
  end

  def manage_filters
    locale_filter, letter_filter = params[:locale], params[:letter]

    if not locale_filter and not letter_filter
      new_params = { locale: locale }
      new_params.merge!(letter: letter) if letter

      flash.keep
      redirect_to user_picked_words_url(user, new_params)
    else
      store_in_session(locale_filter: locale_filter, letter_filter: nil) if locale_filter
      store_in_session(letter_filter: letter_filter) if letter_filter
    end

    return true
  end

  def expire_cached_content(pick)
    expire_fragment pick
    expire_action controller: 'picked_words', action: 'show', user_id: user.to_param, id: pick.to_param
  end

  def locale
    session[:locale_filter] ||= I18n.locale
  end

  def letter
    session[:letter_filter]
  end
end
