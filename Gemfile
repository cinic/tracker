source 'https://rubygems.org'
source 'https://rails-assets.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'

gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.1'
gem 'font-awesome-sass'
gem 'rails-assets-d3-tip'
gem 'lodash-rails'
gem 'd3-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
gem 'rails-assets-angular-moment'

# gem 'rails-assets-angular-cookies'

gem 'rails-assets-angular-cookie'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# queue for pending tasks
gem 'delayed_job_active_record'
gem 'delayed_job_web'
gem 'daemons'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'modernizr-rails'
gem 'slim-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Authorize users
gem 'devise'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# Levenshtein distance for duplicated packet
gem 'levenshtein-ffi', require: 'levenshtein'

# Pagination
gem 'kaminari-bootstrap', '~> 3.0.1'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Server and workers
gem 'puma'
gem 'foreman'

group :development do
  gem 'capistrano', '~> 3.2.0'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rails', '~> 1.1'
  gem 'letter_opener'
  gem 'sextant'
  # Debugging
  gem 'better_errors'
  gem 'meta_request'
  gem 'binding_of_caller'

  # disable assets logging in development!!
  gem 'quiet_assets'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0.0'
  gem 'capybara'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'guard-puma'
  gem 'railroady'
  gem 'pry-rails'
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
end

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem 'foundation-rails', '~> 5.4.5.0'
gem 'font-awesome-rails'
gem 'holder_rails'
gem 'angular-rails-templates'
gem 'data_uri_images', github: 'esshka/data_uri_images'
# gem 'momentjs-rails'
gem 'susy'
gem 'compass-rails', '~> 2.0.4'

group :production, :staging do
  # monitoring for application
  gem 'newrelic_rpm'
end

# To use respond_with & respond_to methods
gem 'responders', '~> 2.0'

gem 'active_model_serializers'
gem 'oj'
gem 'activerecord-import'
gem 'groupdate'

group :development do
  gem 'flamegraph'
  gem 'rack-mini-profiler'
  gem 'web-console', '~> 2.0'
end
