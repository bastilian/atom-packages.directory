require 'bundler'
Bundler.require

require 'lib/permalink'
require 'lib/decorator'

LOG_FILE = File.new(File.join(File.dirname(__FILE__), '../log/dev.log'), 'a+')
LOG_FILE.sync = true

Dir.glob(
  File.join(File.dirname(__FILE__), '../{models,helpers,decorators,controllers}/*.rb')
).each { |file| require file }

NoBrainer.configure do |config|
  config.app_name = 'atom_packages'
  config.rethinkdb_urls = [ENV['RETHINKDB_URL']]
  config.logger = Logger.new(LOG_FILE)
end
NoBrainer.sync_indexes
