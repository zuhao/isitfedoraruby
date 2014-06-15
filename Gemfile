source 'https://rubygems.org'
ruby '2.1.2'
#ruby-gemset=fruby

def darwin_only(require_as)
    RUBY_PLATFORM.include?('darwin') && require_as
end

def linux_only(require_as)
    RUBY_PLATFORM.include?('linux') && require_as
end

gem 'rails', '~> 4.0.5'

# temp fix http://stackoverflow.com/a/23525354/2137281
gem 'sprockets', '<= 2.11.0'

# Get latest fixes
gem 'rmagick', git: "https://github.com/rmagick/rmagick.git"

gem 'thor'
gem 'bootstrap-sass'

#i18n support
gem 'fast_gettext'
gem 'gettext_i18n_rails'
gem 'rails-i18n'

gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'

gem 'jquery-rails'
gem 'haml-rails'
gem 'execjs'
gem 'bootstrap-will_paginate'
gem 'curb'
gem 'json'
gem 'nokogiri'
gem 'versionomy'
gem 'gems'
gem 'pkgwat'
gem 'bicho'
gem 'ruby-bugzilla'
gem 'text'

gem 'whenever', :require => false

group :test, :development do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'guard-rspec'
  gem 'ruby_parser'
  gem 'gettext', :require => false
  gem 'sqlite3'
  gem 'annotate'

  # Notification
  gem 'rb-fsevent', require: darwin_only('rb-fsevent')
  gem 'growl', require: darwin_only('growl')
  gem 'rb-inotify', require: linux_only('rb-inotify')

  # models/controllers visualization
  gem 'railroady'

  # Pry-based enhancements for the rails console
  gem 'jazz_hands', github: 'nixme/jazz_hands', branch: 'bring-your-own-debugger'
  gem 'pry-byebug'
end

group :test do
  gem 'faker'
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'rake'
  gem 'coveralls'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'unicorn'
end

