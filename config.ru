$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))

require 'lib/environment'
controllers = Object.constants.select { |c| c.match(/Controller$/) }.map { |c| Kernel.const_get(c) }
run Rack::Cascade.new(controllers)
