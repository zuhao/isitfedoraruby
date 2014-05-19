source 'https://rubygems.org'
ruby '2.1.1'
#ruby-gemset=fedoraruby

def darwin_only(require_as)
    RUBY_PLATFORM.include?('darwin') && require_as
end

def linux_only(require_as)
    RUBY_PLATFORM.include?('linux') && require_as
end

gem 'rails', '~> 4.0.0'

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
  gem 'guard-rspec'
  gem 'capybara'
  gem 'ruby_parser'
  gem 'gettext', :require => false
  gem 'minitest'
  gem 'sqlite3'

  # Notification
  gem 'rb-fsevent', require: darwin_only('rb-fsevent')
  gem 'growl', require: darwin_only('growl')
  gem 'rb-inotify', require: linux_only('rb-inotify')

end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

