require 'bundler'
Bundler.require

require 'lib/hash'
require 'lib/permalink'
require 'lib/decorator'

ROOT            = File.join(File.dirname(__FILE__), '..')
DATABASE_CONFIG = File.join(ROOT, 'mongoid.yml')
LOG_FILE        = File.new(File.join(ROOT, "log/#{ENV['RACK_ENV']}.log"), 'a+')
LOG_FILE.sync = true

Dir.glob(
  File.join(ROOT, '/{models,helpers,decorators,controllers}/*.rb')
).each { |file| require file }

Mongoid.load!(DATABASE_CONFIG, :production)
