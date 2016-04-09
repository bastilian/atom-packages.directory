$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

ENV['RETHINKDB_URL'] = 'rethinkdb://database/atom_test'

require 'lib/environment'
NoBrainer.sync_indexes

RSpec.configure do |c|
end
