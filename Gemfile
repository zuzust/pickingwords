require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']

source 'https://rubygems.org'

gem 'rails', '3.2.3'

gem 'jquery-rails'
gem "haml", ">= 3.1.4"
gem "simple_form"
gem "will_paginate", ">= 3.0.3"
gem "will_paginate_mongoid", ">= 1.0.5"
gem "devise", ">= 2.1.0.rc"
gem "mongoid", ">= 2.4.8"
gem "bson_ext", ">= 1.6.2"

group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'sass-rails',   '~> 3.2.3'
  gem "twitter-bootstrap-rails", ">= 2.0.3"
  gem 'uglifier', '>= 1.0.3'
end

gem "rspec-rails", ">= 2.9.0.rc2", :group => [:development, :test]
gem "fabrication", "~> 1.3.2", :group => [:development, :test]

group :development do
  gem "haml-rails", ">= 0.3.4"
  gem "guard", ">= 0.6.2"

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

  gem "guard-bundler", ">= 0.1.3"
  gem "guard-rails", ">= 0.0.3"
  gem "guard-livereload", ">= 0.3.0"
  gem "rack-livereload", ">= 0.3.6"
  gem "guard-rspec", ">= 0.4.3"
  gem "guard-cucumber", ">= 0.6.1"
  gem "guard-spork", ">= 0.6.1"
  gem "guard-coffeescript", ">= 0.6.0"
end

group :test do
  gem "capybara", ">= 1.1.2"
  gem "cucumber-rails", ">= 1.3.0", :require => false
  gem "email_spec", ">= 1.2.1"
  gem "mongoid-rspec", ">= 1.4.4"
  gem "database_cleaner", ">= 0.7.2"
  gem "launchy", ">= 2.1.0"
  gem "spork-rails", ">= 3.2.0"
  gem "faker", "~> 1.0.1"
end
