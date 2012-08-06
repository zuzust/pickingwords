module PickedWordsHelper

  def emphasize(word, sentence)
    pattern = word.sub(/\s+/, '.*')
    raw(sentence.gsub(/#{pattern}\w*/i) { |s| "<strong>#{s}</strong>" })
  end

end
