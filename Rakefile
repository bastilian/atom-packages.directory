$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))
require 'pry'
require 'sinatra/asset_pipeline/task'
require 'lib/environment'
Sinatra::AssetPipeline::Task.define! ApplicationController

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

Dir.glob('lib/tasks/*.rake').each { |r| import r }
task :console do
  pry
end
