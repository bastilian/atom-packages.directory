$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

ENV['RETHINKDB_URL'] = 'rethinkdb://database/atom_test'
require 'lib/environment'
require 'factory_girl'
require 'faker'

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    NoBrainer.sync_indexes
  end

  config.before(:all) do
    NoBrainer.drop!
    NoBrainer.sync_schema
    FactoryGirl.find_definitions
  end

  config.before(:each) do
    NoBrainer.purge!
  end
end
