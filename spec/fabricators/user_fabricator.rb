# Read about fabricators at http://fabricationgem.org/

Fabricator(:user) do
  transient :role
  name                  { Faker::Name.name }
  email                 { |attrs| "#{attrs[:name].parameterize}@example.com" }
  password              'please'
  password_confirmation 'please'
  # required if the Devise Confirmable module is used
  confirmed_at          { Time.now }

  roles(count: 1) { |user, i| user[:role] ? Fabricate(:role, name: user[:role]) : Fabricate(:role, name: 'picker') }
end
