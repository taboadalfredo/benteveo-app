ENV['RACK_ENV'] ||= 'test'

require 'rack/test'
require 'rspec'
require 'database_cleaner/active_record'

require_relative '../app/app'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  DatabaseCleaner.allow_remote_database_url = true

  def app
    App
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'sqlite3:db/test.sqlite3')
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning { example.run }
  end
end
