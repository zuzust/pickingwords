class PickedWordsController < ApplicationController
  respond_to :html, :json
  helper_method :locale, :letter, :favs

  before_filter :authenticate_user!
  before_filter :format_request_params, only: [:create, :update]
  before_filter :manage_filters, only: :index
  load_and_authorize_resource

  caches_action :show, layout: false, expires_in: 24.hours

  def index
    @picked_words = @picked_words.localized_in(locale).beginning_with(letter)
    @picked_words = @picked_words.faved if favs

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
      flash[:notice] = 'Word successfully picked.'
    end

    respond_with(user, @picked_word)
  end

  def update
    if @picked_word.update_attributes(params[:picked_word])
      expire_cached_content(@picked_word)
      flash[:notice] = 'Pick successfully updated.'
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
    locale_filter = params[:locale]

    if locale_filter
      letter_filter, favs_filter = params[:letter], params[:favs]
      store_in_session(locale_filter: locale_filter, letter_filter: nil, favs_filter: nil)
      store_in_session(letter_filter: letter_filter) if letter_filter
      store_in_session(favs_filter: favs_filter) if favs_filter
    else
      req_params = { locale: locale }
      req_params.merge!(letter: letter) if letter
      req_params.merge!(favs: favs) if favs

      flash.keep
      redirect_to user_picked_words_url(user, req_params)
    end

    return true
  end

  def expire_cached_content(pick)
    expire_fragment pick
    expire_action controller: 'picked_words', action: 'show', user_id: user.to_param, id: pick.id.to_s
  end

  def locale
    session[:locale_filter] ||= I18n.locale
  end

  def letter
    session[:letter_filter]
  end

  def favs
    session[:favs_filter]
  end
end
