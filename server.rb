require 'sinatra/asset_pipeline'
require 'lib/environment'

# Server instance serves the site. Tada!
class Server < Sinatra::Base
  # Partials support for views
  register Sinatra::Partial
  set :partial_template_engine, :erb

  # Sprockets asset pipeline
  register Sinatra::AssetPipeline

  configure do
    enable :logging
    use Rack::CommonLogger, LOG_FILE
  end

  before do
    NoBrainer.sync_schema
  end

  get '/' do
    @packages = Package.all.limit(20)
    erb :index
  end

  get '/:category' do
    @category = Category.where(permalink: params[:category])
    erb :category
  end

  post '/category' do
    @category = Category.where(name: params[:name]).first_or_create(description: params[:description])
    erb :category
  end

  get '/keyword/:keyword' do
    @packages = Package.where(:keywords.include => params[:keyword])
    erb :index
  end

  get '/package/:permalink' do
    @package = Package.where(permalink: params[:permalink]).first
    erb :package
  end

  helpers do
    def markdown(string)
      Kramdown::Document.new(string).to_html
    end
  end
end
