source 'https://rubygems.org'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'
# Use Slim lang for templates
gem 'slim-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', github: 'turbolinks/turbolinks-classic'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1', '>= 3.1.10'
##
## Additional gems
##
# react-rails eases React integration
gem 'react-rails', '~> 1.6.0'
# browserify-rails helps with Browserify integration within Rails
gem 'browserify-rails'
# i18n Russian translation
gem 'russian', '~> 0.6.0'
# queue for pending tasks
gem 'delayed_job_active_record'
gem 'delayed_job_web'
gem 'daemons'
# Authorize users
gem 'devise'
# Pagination
gem 'kaminari-bootstrap', '~> 3.0.1'
# Server and workers exporter
gem 'foreman'
# To use respond_with & respond_to methods
gem 'responders'
gem 'oj'
gem 'i18n-js', '>= 3.0.0.rc12'

group :development, :test do
  gem 'thin'
  gem 'awesome_print'
  gem 'byebug'
  gem 'rspec-rails', '~> 3.0.0'
  gem 'jasmine-rails'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-jasmine'
  gem 'guard-rspec'
  gem 'guard-shell'
  gem 'guard-puma'
end

group :development do
  gem 'capistrano', '~> 3.2.0'
  gem 'capistrano-rbenv'
  gem 'capistrano-npm'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rails', '~> 1.1'
  # Debugging
  gem 'better_errors'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the
  # background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 1.6.3'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'database_cleaner'
  gem 'simplecov', require: false
end

group :production, :staging, :front do
  gem 'puma'
  # monitoring for application
  gem 'newrelic_rpm'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end
