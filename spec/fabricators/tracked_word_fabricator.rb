Fabricator(:tracked_word) do
  name     { RandomWord.nouns.next }
  searches 1
  picked   0
  favs     0
end
