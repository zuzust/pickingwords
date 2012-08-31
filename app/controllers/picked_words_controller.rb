class PickedWordsController < ApplicationController
  respond_to :html, :json
  helper_method :locale, :letter, :favs

  before_filter :authenticate_user!
  before_filter :manage_filters, only: :index
  before_filter :format_search_params, only: :search
  before_filter :format_request_params, only: [:create, :update]
  before_filter :load_cached_resource, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource except: :search

  caches_action :show, layout: false, expires_in: 1.hour

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
      store_in_session(locale_filter: @picked_word.from_lang, letter_filter: @picked_word.name.chr, favs_filter: nil)
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

  def search
    authorize! :search, :word
    sf = SearchForm.new(params[:sf])

    respond_to do |format|
      if sf.valid?
        @picked_words = search_matching_picks(user.picks, sf.name, sf.from, sf.to)

        if @picked_words.size == 0 and not (sf.from.blank? or sf.to.blank?)
          format.html { redirect_to user_translate_url(user, sf.to_params) }
          format.json { head :temporary_redirect, location: user_translate_url(user, sf.to_params) }
        else
          store_in_session(letter_filter: nil, favs_filter: nil)

          format.html { render :index }
          format.json { render json: @picked_words }
        end
      else
        format.html { redirect_to user_picked_words_url(user, locale: locale, letter: letter, favs: favs), alert: sf.error_messages }
        format.json { render json: sf.errors, status: :unprocessable_entity }
      end
    end
  end

private

  def manage_filters
    if params[:locale]
      store_in_session(locale_filter: params[:locale], letter_filter: params[:letter], favs_filter: params[:favs])
      return true
    else
      flash.keep
      redirect_to user_picked_words_url(user, locale: locale, letter: letter, favs: favs) and return
    end
  end

  def format_search_params
    params[:sf] = {
      name: params[:name],
      from: params[:from],
      to:   params[:to],
      ctxt: params[:ctxt]
    }
  end

  def format_request_params
    params[:picked_word][:contexts_attributes] ||= {}
    params[:picked_word].merge!(contexts_attributes: params[:picked_word][:contexts_attributes].values)
  end

  def load_cached_resource
    @picked_word = PickedWord.fetch(params[:id])
  end

  def search_matching_picks(picks, name, from, to)
    from = locale if from.blank?
    picks = picks.search(name, from, to)

    store_in_session(locale_filter: from) if picks.size > 0
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
