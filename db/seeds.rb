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
user = User.create! :name => 'devel', :email => 'devel@example.com', :password => 'secret', :password_confirmation => 'secret', :confirmed_at => Time.now.utc
puts 'New user created: ' << user.name

puts 'SETTING UP SAMPLE TRACKED WORDS'
twords = []
twords << TrackedWord.create!(:word_attributes => { :name => "awesome" })
twords << TrackedWord.create!(:word_attributes => { :name => "cumbersome" })
twords << TrackedWord.create!(:word_attributes => { :name => "wonderful" })
puts 'New tracked words created: ' << twords.map(&:name).to_sentence
