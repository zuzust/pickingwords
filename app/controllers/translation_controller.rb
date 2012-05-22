class TranslationController < ApplicationController
  # POST /translation/translate
  # POST /translation/translate.json
  def translate
    tf = TranslationForm.new(params[:translation_form])

    respond_to do |format|
      if tf.valid?
        @picked_word = PickedWord.search(tf.name, tf.from_lang, tf.to_lang)

        if @picked_word
          format.html { render 'picked_words/show' }
        else
          tracked = TrackedWord.update_or_create(tf.from_lang, tf.name, tf.to_lang, tf.translation)
          @picked_word = tracked.picks.build(tf.word_attributes)
          format.html { render 'picked_words/new' }
        end

        format.json { render json: @picked_word }
      else
        format.html { redirect_to picked_words_url, alert: tf.errors.full_messages.to_sentence }
        format.json { render json: tf }
      end
    end
  end
end
