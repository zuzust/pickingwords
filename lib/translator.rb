class Translator

  class ServiceProviderError < StandardError ; end

  class << self
    def client_id
      ENV["MST_CLIENT_ID"]
    end

    def client_secret
      ENV["MST_CLIENT_SECRET"]
    end

    def provider
      @provider ||= BingTranslator.new(client_id, client_secret)
    end

    def translate(word, from_lang, to_lang, ctxt)
      tracked,  word_tchars = track_translation(word, from_lang, to_lang)
      pickable, ctxt_tchars = build_pickable(tracked, word, from_lang, to_lang, ctxt)

      [pickable, word_tchars + ctxt_tchars]
    end

  private

    def track_translation(word, from_lang, to_lang)
      trans_chars = 0

      tracked = TrackedWord.search(word, from_lang)
      tracked ||= TrackedWord.new.localize(from_lang, word)

      unless tracked.translate(to_lang)
        translation, trans_chars = get_translation(word, from_lang, to_lang)
        tracked.localize(to_lang, translation)
      end

      tracked.save

      [tracked, trans_chars]
    end

    def build_pickable(tracked, word, from_lang, to_lang, ctxt)
      trans_chars = 0

      translation = tracked.translate(to_lang)
      pickable    = tracked.picks.build(name: word, from_lang: from_lang, to_lang: to_lang, translation: translation)

      unless ctxt.blank?
        translation, trans_chars = get_translation(ctxt, from_lang, to_lang)
        pickable.contexts.build(sentence: ctxt, translation: translation)
      end

      [pickable, trans_chars]
    end

    def get_translation(text, from_lang, to_lang)
      begin
        translation = provider.translate(text, from: from_lang, to: to_lang)
        trans_chars = text.length

        [translation, trans_chars]
      rescue StandardError
        raise Translator::ServiceProviderError, "Sorry, translation service not responding. Try it again in a few minutes."
      end
    end
  end

end
