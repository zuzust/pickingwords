# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts 'EMPTY THE MONGODB DATABASE'
Mongoid.master.collections.reject { |c| c.name =~ /^system/}.each(&:drop)


puts 'SETTING UP DEFAULT ADMIN'
admin = Admin.create!(email: 'admin@example.com', password: 'secret')
puts "New admin created: #{admin.email}"


puts 'SETTING UP SAMPLE USERS'
users = []
u_attrs = [
  { name: 'user',  email: 'user@example.com',  :password => 'secret', :password_confirmation => 'secret', :confirmed_at => Time.now.utc },
  { name: 'guest', email: 'guest@example.com', :password => 'secret', :password_confirmation => 'secret', :confirmed_at => Time.now.utc }
]

u_attrs.each do |attrs|
  User.create!(attrs).tap do |user|
    users << user
  end
end

puts "New users created: " << users.map(&:name).to_sentence


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
