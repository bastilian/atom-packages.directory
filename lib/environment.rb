require 'bundler'
Bundler.require

LOG_FILE = File.new(File.join(File.dirname(__FILE__), '../log/dev.log'), 'a+')
LOG_FILE.sync = true

NoBrainer.configure do |config|
  config.app_name = 'atom_packages'
  config.rethinkdb_urls = [ENV['RETHINKDB_URL']]
  config.logger = Logger.new(LOG_FILE)
end

require 'lib/permalink'
require 'models/package'
require 'models/category'
require 'models/package_categorisation'
