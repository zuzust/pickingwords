Fabricator(:word) do
  name { RandomWord.nouns.next }
end
