require 'lib/environment'
require 'sinatra/asset_pipeline'

class ApplicationController < Sinatra::Base
  helpers ApplicationHelpers

  # Partials support for views
  register Sinatra::Partial
  set :partial_template_engine, :erb
  set :views, File.join(File.dirname(__FILE__), '../views')

  set :assets_precompile, %w(*.coffee *.scss *.png *.jpg *.svg *.eot *.ttf *.woff *.woff2)

  set :assets_prefix, %w(../assets ../assets/javascripts/bower_components)
  register Sinatra::AssetPipeline

  configure do
    enable :logging
    use Rack::CommonLogger, LOG_FILE
  end

  before do
    NoBrainer.sync_schema
    @categories = Category.all
  end

  get '/' do
    erb :index, locals: { top_categories: Category.top }
  end
end
