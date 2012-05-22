Fabricator(:word_context) do
  sentence    { Faker::Lorem.sentence(5) }
  translation { Faker::Lorem.sentence(5) }
  pick        { Fabricate(:picked_word) }
end
