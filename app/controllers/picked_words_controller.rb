class PickedWordsController < ApplicationController
  respond_to :html, :json
  helper_method :locale, :letter, :favs

  before_filter :authenticate_user!
  before_filter :format_request_params, only: [:create, :update]
  before_filter :manage_filters, only: :index
  before_filter :load_resources, only: :index
  before_filter :load_cached_resource, except: [:index, :create]
  load_and_authorize_resource

  caches_action :show, layout: false, expires_in: 1.hour

  def index
    if params[:name]
      # search mode
      @picked_words = index_matched_name(@picked_words, params[:name], params[:from], params[:to])
    else
      # filter mode
      @picked_words = @picked_words.localized_in(locale).beginning_with(letter)
      @picked_words = @picked_words.faved if favs
    end

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
      flash[:notice] = 'Word successfully picked'
    end

    respond_with(user, @picked_word)
  end

  def update
    if @picked_word.update_attributes(params[:picked_word])
      expire_cached_content(@picked_word)
      flash[:notice] = 'Pick successfully updated'
    end

    respond_with(user, @picked_word)
  end

  def destroy
    @picked_word.destroy
    expire_cached_content(@picked_word)
    flash[:notice] = 'Pick successfully deleted'

    respond_with(user, @picked_word)
  end

private

  def format_request_params
    params[:picked_word][:contexts_attributes] ||= {}
    params[:picked_word].merge!(contexts_attributes: params[:picked_word][:contexts_attributes].values)
  end

  def manage_filters
    locale_filter, name_filter = params[:locale], params[:name]

    if locale_filter
      store_in_session(locale_filter: locale_filter, letter_filter: params[:letter], favs_filter: params[:favs])
    elsif name_filter
      store_in_session(letter_filter: name_filter.chr, favs_filter: nil)
    else
      flash.keep
      redirect_to user_picked_words_url(user, locale: locale, letter: letter, favs: favs) and return
    end

    return true
  end

  def load_resources
    key = "#{user.to_param}/picked_words/search_results"
    @picked_words = load_from_cache(key)
    @picked_words ||= user.picks
  end

  def load_cached_resource
    @picked_word = PickedWord.fetch(params[:id])
  end

  def index_matched_name(picks, name, from, to)
    key = "#{user.to_param}/picked_words/search_results"

    unless stored_in_cache?(key)
      from ||= locale
      picks = picks.search(name, from, to)
      store_in_session(locale_filter: from) if picks.size > 0
    else
      expire_from_cache key
    end

    picks.each { |pick| expire_cached_content pick }
    picks
  end

  def expire_cached_content(pick)
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
