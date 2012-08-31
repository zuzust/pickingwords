class TranslationController < ApplicationController
  respond_to :html, :json
  before_filter :authenticate_user!
  before_filter :format_translate_params

  def translate
    authorize! :translate, :word
    tf = TranslationForm.new(params[:tf])

    respond_to do |format|
      if tf.valid?
        tracked = TrackedWord.update_or_create(tf.from, tf.name, tf.to, tf.translation)
        @picked_word = tracked.picks.build(tf.word_attributes)

        flash.now[:info] = "Not among your picks yet, so we've borrowed it for you"
        format.html { render 'picked_words/new' }
        format.json { render json: @picked_word }
      else
        format.html { redirect_to user_picked_words_url(user, locale: locale, letter: letter, favs: favs), alert: tf.error_messages }
        format.json { render json: tf.errors, status: :unprocessable_entity }
      end
    end
  end

private

  def format_translate_params
    params[:tf] = {
      name: params[:name],
      from: params[:from],
      to:   params[:to],
      ctxt: params[:ctxt]
    }
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
