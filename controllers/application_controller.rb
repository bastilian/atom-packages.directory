require 'lib/environment'
require 'sinatra/asset_pipeline'

class ApplicationController < Sinatra::Base
  # Partials support for views
  register Sinatra::Partial
  set :partial_template_engine, :erb
  set :views, File.join(File.dirname(__FILE__), '../views')
  set :assets_prefix, %w(../assets)

  # Sprockets asset pipeline
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
    @top_categories = Category.top
    erb :index
  end

  helpers do
    def markdown(string)
      Kramdown::Document.new(string).to_html
    end

    def humanize_atom_package_name(string)
      string.gsub!(/^language-/, '')
      string.gsub!(/-ui$/, '')
      string.tr!('-', ' ')
      string.split(/(\W)/).map(&:capitalize).join
    end
  end
end
