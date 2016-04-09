$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))

Dir.glob('./{helpers,controllers}/*.rb').each { |file| require file }

run Rack::Cascade.new([
  PackagesController,
  PackageCategorisationsController,
  CategoriesController,
  ApplicationController
])
