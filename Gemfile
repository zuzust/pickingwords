require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']

source 'https://rubygems.org'
ruby "1.9.3"

gem 'rails', '3.2.6'

gem 'jquery-rails', '>= 2.0.2'
gem 'bootstrap-sass', '>= 2.0.3.1'
gem 'haml', '>= 3.1.6'
gem 'simple_form', '>= 2.0.2'
gem 'will_paginate', '>= 3.0.3'
gem 'will_paginate_mongoid', '>= 1.0.5'
gem 'bootstrap-will_paginate', '>= 0.0.7'
gem 'bson_ext', '>= 1.6.4'
gem 'mongoid', '>= 2.4.11'
gem 'mongoid_magic_counter_cache', '>= 0.1.1'
gem 'devise', '>= 2.1.2'
gem 'cancan', '>= 1.6.8'
gem 'rolify', '>= 3.1.0'
gem 'bing_translator', '>= 3.0.0'

group :assets do
  gem 'coffee-rails', '>= 3.2.2'
  gem 'sass-rails',   '>= 3.2.5'
  gem 'uglifier', '>= 1.2.4'
  gem 'font-awesome-sass-rails', '>= 2.0.0.0'
end

gem 'rspec-rails', '>= 2.10.1', :group => [:development, :test]
gem 'fabrication', '>= 2.1.0', :group => [:development, :test]
gem 'pry-rails', '>= 0.1.6', :group => [:development, :test]

group :development do
  gem 'haml-rails', '>= 0.3.4'
  gem 'guard', '>= 1.2.3'

  case HOST_OS
    when /darwin/i
      gem 'rb-fsevent'
      gem 'growl'
    when /linux/i
      gem 'libnotify'
      gem 'rb-inotify'
    when /mswin|windows/i
      gem 'rb-fchange'
      gem 'win32console'
      gem 'rb-notifu'
  end

  gem 'guard-bundler', '>= 1.0.0'
  gem 'guard-rails', '>= 0.1.0'
  gem 'guard-livereload', '>= 1.0.0'
  gem 'rack-livereload', '>= 0.3.6'
  gem 'guard-rspec', '>= 1.1.0'
  gem 'guard-cucumber', '>= 1.1.0'
  gem 'guard-spork', '>= 1.0.0'
  gem 'guard-coffeescript', '>= 1.0.0'
  gem 'bullet', '>= 4.1.4'
end

group :test do
  gem 'capybara', '>= 1.1.2'
  gem 'cucumber-rails', '>= 1.3.0', :require => false
  gem 'email_spec', '>= 1.2.1'
  gem 'mongoid-rspec', '>= 1.4.5'
  gem 'database_cleaner', '>= 0.8.0'
  gem 'launchy', '>= 2.1.0'
  gem 'spork-rails', '>= 3.2.0'
  gem 'faker', '>= 1.0.1'
  gem 'random-word', '>= 1.3.0'
  gem 'webmock', '>= 1.8.9'
  gem 'simplecov', '>= 0.6.4', :require => false
end

group :production do
  gem 'thin'
  gem 'dalli'
  gem 'newrelic_rpm'
end
