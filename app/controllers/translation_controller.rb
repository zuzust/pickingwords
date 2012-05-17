class TranslationController < ApplicationController
  respond_to :html, :json

  # GET /translation/translate
  # GET /translation/translate.json
  def translate
    from_lang   = params[:word][:fl]
    name        = params[:word][:n]
    to_lang     = params[:word][:tl]
    translation = params[:word][:t]

    @picked_word = PickedWord.search(name, from_lang, to_lang)

    respond_with(@picked_word) do |format|
      if @picked_word
        format.html { render 'picked_words/show' }
      else
        @tracked = TrackedWord.update_or_create(from_lang, name, to_lang, translation)
        @picked_word = @tracked.picks.build(from_lang: from_lang, name: name,
                                            to_lang: to_lang, translation: translation)

        format.html { render 'picked_words/new' }
      end

      format.json { render json: @picked_word }
    end
  end
end
