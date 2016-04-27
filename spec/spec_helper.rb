$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
require 'factory_girl'
require 'faker'
require 'rack/test'

ENV['RACK_ENV'] = 'test'
ENV['RETHINKDB_URL'] = 'rethinkdb://database/atom_test'

require 'lib/environment'
require 'support/controller_mixins'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include ControllerMixins, type: :controller

  config.before(:suite) do
    FactoryGirl.find_definitions
    NoBrainer.sync_indexes
  end

  config.before(:all) do
    NoBrainer.drop!
    NoBrainer.sync_schema
  end

  config.before(:each) do
    NoBrainer.purge!
  end
end

def puts(*_); end
