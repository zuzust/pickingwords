Fabricator(:user_profile) do
  user        { Fabricate(:user) }
  trans_chars 0
  searches    0
  picked      0
  favs        0
end
