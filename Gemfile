source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.0'
# for heroku
gem 'rails_12factor', group: :production
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
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

gem 'websocket-rails'
gem 'angularjs-rails', '1.3.0'
# preload angular templates, no async request required

# breaks on angular 1.3.1 sucks!!
gem 'angular-rails-templates'
group :development, :test do
  gem 'jasmine'
  gem 'pry'
end
# coverage
group :test do
  gem 'simplecov', '~> 0.9.0',require: false
  gem 'webmock'
  gem 'cucumber-rails', require: false
  gem 'minitest'
  gem 'cucumber'
  gem 'poltergeist'
  gem 'capybara_minitest_spec'
  # database_cleaner is not required, but highly recommended
  gem 'database_cleaner'
end