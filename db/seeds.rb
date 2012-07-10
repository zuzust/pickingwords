# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts 'EMPTY THE MONGODB DATABASE'
Mongoid.master.collections.reject { |c| c.name =~ /^system/}.each(&:drop)


puts 'SETTING UP DEFAULT USER LOGIN'
users = []
u_attrs = [
  {roles: ['admin'],  user: {name: 'admin', email: 'admin@example.com', :password => 'admin', :password_confirmation => 'admin', :confirmed_at => Time.now.utc}},
  {roles: ['devel'],  user: {name: 'devel', email: 'devel@example.com', :password => 'devel', :password_confirmation => 'devel', :confirmed_at => Time.now.utc}},
  {roles: ['picker'], user: {name: 'user',  email: 'user@example.com',  :password => 'user',  :password_confirmation => 'user',  :confirmed_at => Time.now.utc}}
]

u_attrs.each do |attrs|
  User.create!(attrs[:user]).tap do |user|
    attrs[:roles].each { |role| user.add_role role }
    users << user
  end
end

puts 'New users created: ' << users.map(&:name).to_sentence


puts 'SETTING UP SAMPLE TRACKED WORDS'
twords = []
tw_attrs = [
  { name: "awesome" },
  { name: "cumbersome" },
  { name: "wonderful" }
]

tw_attrs.each do |attrs|
  TrackedWord.find_or_create_by(name: attrs[:name]).tap do |tw|
    twords << tw
  end
end

puts 'New tracked words created: ' << twords.map(&:name).to_sentence
