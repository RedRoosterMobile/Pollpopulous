source 'https://rubygems.org'

ruby '2.3.1'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# for heroku
gem 'rails_12factor', group: :production
# Use sqlite3 as the database for Active Record
group :development, :test do
  gem 'sqlite3'
end


gem 'pg' ,group: :production
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
gem 'compass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
gem 'nokogiri', '~> 1.6.8.rc2'
gem 'haml-rails'
gem 'sidekiq'

# https://community.codeship.com/t/nokogiri-isnt-installing-on-ruby-2-3/19/3
gem 'faye-websocket', '0.10.0'
gem 'websocket-rails'
gem 'angularjs-rails'
# preload angular templates, no async request required

gem 'angular-rails-templates'
group :development, :test do
  gem 'jasmine'
  gem 'byebug'
  gem 'coveralls', require: false
end
# coverage
group :test, :development do
  gem 'simplecov',require: false
  gem 'webmock'
  gem 'cucumber-rails', require: false
  gem 'minitest'
  gem 'cucumber'
  gem 'poltergeist'
  gem 'capybara_minitest_spec'

  # database_cleaner is not required, but highly recommended
  gem 'database_cleaner'
end
