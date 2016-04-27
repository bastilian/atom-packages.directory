require 'bundler'
Bundler.require

require 'lib/permalink'
require 'lib/decorator'

LOG_FILE = File.new(File.join(File.dirname(__FILE__), "../log/#{ENV['RACK_ENV']}.log"), 'a+')
LOG_FILE.sync = true

Dir.glob(
  File.join(File.dirname(__FILE__), '../{models,helpers,decorators,controllers}/*.rb')
).each { |file| require file }

NoBrainer.configure do |config|
  config.app_name = 'atom_packages'
  config.rethinkdb_urls = ["rethinkdb://#{ENV['RETHINKDB_HOST']}/#{ENV['RETHINKDB_DB']}"]
  config.logger = Logger.new(LOG_FILE)
  config.per_thread_connection = true
end

NoBrainer.sync_schema
NoBrainer.sync_indexes
