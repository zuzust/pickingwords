class TranslationController < ApplicationController
  before_filter :authenticate_user!

  # POST /translation/translate
  # POST /translation/translate.json
  def translate
    authorize! :translate, :word

    tf = TranslationForm.new(params[:tf])

    respond_to do |format|
      if tf.valid?
        user.update_counter(:searches, 1)

        @picked_word = user.picks.search(tf.name, tf.from_lang, tf.to_lang)

        if @picked_word
          expire_cached_content(@picked_word)
          set_session_filters(locale_filter: tf.from_lang, letter_filter: tf.name.chr)
          format.html { render 'picked_words/show' }
        else
          tracked = TrackedWord.update_or_create(tf.from_lang, tf.name, tf.to_lang, tf.translation)
          @picked_word = tracked.picks.build(tf.word_attributes)
          format.html { render 'picked_words/new' }
        end

        format.json { render json: [user, @picked_word] }
      else
        format.html { redirect_to user_picked_words_url(user), alert: tf.error_messages }
        format.json { render json: tf }
      end
    end
  end

private

  def expire_cached_content(picked)
    expire_fragment picked
    expire_action controller: 'picked_words', action: 'show', user_id: user.to_param, id: picked.to_param
  end

  # def set_session_filters(tf)
  #   session[:locale_filter] = tf.from_lang
  #   session[:letter_filter] = tf.name.chr
  # end

end
