class TranslationController < ApplicationController
  respond_to :html, :json
  before_filter :authenticate_user!
  before_filter :format_request_params

  def translate
    authorize! :translate, :word

    tf = TranslationForm.new(params[:tf])

    respond_to do |format|
      if tf.valid?
        user.update_counter(:searches, 1)

        if tf.from.blank? or tf.to.blank?
          req_params = { name: tf.name }
          req_params.merge!(from: tf.from) unless tf.from.blank?
          req_params.merge!(to: tf.to) unless tf.to.blank?

          format.html { redirect_to user_picked_words_url(user, req_params) }
          format.json { head :ok }
        else
          resources = user.picks.search(tf.name, tf.from, tf.to)

          if resources.exists?
            cache_resources(resources)
            # there aren't two resources with the same name, from_lang and to_lang 
            pick = resources.first
            req_params = { name: pick.name, from: pick.from_lang, to: pick.to_lang }

            format.html { redirect_to user_picked_words_url(user, req_params) }
            format.json { render json: pick, location: pick }
          else
            tracked = TrackedWord.update_or_create(tf.from, tf.name, tf.to, tf.translation)
            @picked_word = tracked.picks.build(tf.word_attributes)

            flash.now[:info] = "Not among your picks yet, so we've borrowed it for you"
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

  def format_request_params
    params[:tf] = {
      name: params[:name],
      from: params[:from],
      to:   params[:to],
      ctxt: params[:ctxt]
    }
  end

  def cache_resources(resources)
    key = "#{user.to_param}/picked_words/search_results"
    store_in_cache(key => resources)
  end
end
