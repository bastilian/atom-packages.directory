$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

ENV['RETHINKDB_URL'] = 'rethinkdb://database/atom_test'
require 'lib/environment'
require 'factory_girl'
require 'faker'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

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
