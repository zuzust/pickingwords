Fabricator(:tracked_word) do
  name     { RandomWord.nouns.next }
  searches 0
  picked   0
  favs     0
end
