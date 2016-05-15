$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
require 'factory_girl'
require 'faker'
require 'database_cleaner'

require 'rack/test'

ENV['RACK_ENV'] = 'test'

require 'lib/environment'
require 'support/controller_mixins'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include ControllerMixins, type: :controller

  config.before(:suite) do
    FactoryGirl.find_definitions
  end

  config.before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end

def puts(*_); end
