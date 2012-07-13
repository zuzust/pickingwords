module PickedWordsHelper

  def locale
    session[:locale_filter]
  end

  def letter
    session[:letter_filter]
  end

  def emphasize(word, sentence)
    pattern = word.sub(/\s+/, '.*')
    raw(sentence.gsub(/#{pattern}\w*/i) { |s| "<strong>#{s}</strong>" })
  end

end
