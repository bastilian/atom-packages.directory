$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))

require './server'
NoBrainer.sync_schema

require 'sinatra/asset_pipeline/task'
Sinatra::AssetPipeline::Task.define! Server

Dir.glob('lib/tasks/*.rake').each { |r| import r }
