require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/features/'
  add_filter '/config/'
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Helpers', 'app/helpers'
  # add_group 'Views', 'app/views' # only .rb files are included at present!
  add_group 'Libraries', 'lib'
end
require 'capybara/rspec'
require 'factory_girl_rails'

# Set the default driver
Capybara.javascript_driver = :webkit
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
RSpec.configure do |config|
  # Database Cleaner
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
  config.include UserHelper, type: :controller
end
