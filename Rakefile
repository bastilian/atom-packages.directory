$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))

require 'lib/environment'
NoBrainer.sync_schema
Dir.glob('lib/tasks/*.rake').each { |r| import r }
