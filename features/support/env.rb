require 'cucumber/rails'
require 'capybara/poltergeist'


Capybara.default_selector = :css

Capybara.default_driver = :selenium
Capybara.register_driver :selenium do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  Capybara::Selenium::Driver.new(app,:browser => :firefox)
end

ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Cucumber::Rails::Database.javascript_strategy = :truncation
DatabaseCleaner.strategy = :truncation

Capybara.javascript_driver = :poltergeist