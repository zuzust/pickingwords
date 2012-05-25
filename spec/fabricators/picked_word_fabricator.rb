Fabricator(:picked_word) do
  from_lang   { I18n.default_locale }
  name        { RandomWord.nouns.next }
  to_lang     "ca"
  translation { |pw| "#{pw.name}_#{pw.to_lang}" }
  fav         false
  searches    1
  user        { Fabricate(:user) }
  tracked     { |pw| Fabricate(:tracked_word, name: pw.name) }
end
