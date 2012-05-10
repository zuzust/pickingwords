Fabricator(:tracked_word) do
  searches 1
  picked   0
  favs     0
  word     { |tracked| Fabricate(:word, :tracked => tracked) }
end
