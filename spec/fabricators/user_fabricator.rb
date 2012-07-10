# Read about fabricators at http://fabricationgem.org/

Fabricator(:user) do
  name                  { Faker::Name.name }
  email                 { |attrs| "#{attrs[:name].parameterize}@example.com" }
  password              'please'
  password_confirmation 'please'
  # required if the Devise Confirmable module is used
  confirmed_at          { Time.now }
end
