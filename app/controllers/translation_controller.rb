class TranslationController < ApplicationController
  respond_to :html, :json
  before_filter :authenticate_user!

  def translate
    authorize! :translate, :word

    tf = TranslationForm.new(params[:tf])

    respond_to do |format|
      if tf.valid?
        user.update_counter(:searches, 1)

        if tf.from_lang.blank? or tf.to_lang.blank?
          req_params = { name: tf.name }
          req_params.merge!(from: tf.from_lang) unless tf.from_lang.blank?
          req_params.merge!(to: tf.to_lang) unless tf.to_lang.blank?

          format.html { redirect_to user_picked_words_url(user, req_params) }
          format.json { head :ok }
        else
          resources = user.picks.search(tf.name, tf.from_lang, tf.to_lang)

          if resources.exists?
            cache_resources(resources)
            # there aren't two resources with the same name, from_lang and to_lang 
            pick = resources.first
            req_params = { name: pick.name, from: pick.from_lang, to: pick.to_lang }

            format.html { redirect_to user_picked_words_url(user, req_params) }
            format.json { render json: pick, location: pick }
          else
            tracked = TrackedWord.update_or_create(tf.from_lang, tf.name, tf.to_lang, tf.translation)
            @picked_word = tracked.picks.build(tf.word_attributes)

            format.html { render 'picked_words/new' }
            format.json { render json: @picked_word }
          end
        end
      else
        format.html { redirect_to user_picked_words_url(user), alert: tf.error_messages }
        format.json { render json: tf }
      end
    end
  end

private

  def cache_resources(resources)
    key = "#{user.to_param}/picked_words/search_results"
    store_in_cache(key => resources)
  end
end
