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
    @categories = Category.all
  end

  get '/' do
    @top_categories = Category.top

    erb :index
  end

  get '/keyword/:keyword' do
    @packages = Package.where(:keywords.include => params[:keyword])

    erb :index
  end

  get '/:category' do
    @category = Category.where(permalink: params[:category]).first

    erb :category
  end

  post '/category' do
    @category = Category.where(name: params[:name]).first_or_create(description: params[:description])

    erb :category
  end

  get '/package/:permalink' do
    @package = Package.where(permalink: params[:permalink]).first

    erb :package
  end

  get '/categorise/:package/as/:category' do
    @package = Package.where(permalink: params[:package]).first
    @category = Category.where(permalink: params[:category]).first_or_create(name: params[:category].capitalize)
    @category.save
    @package.categorise(@category)

    redirect to("/package/#{@package.permalink}")
  end

  get '/subcategorise/:category/as/:parent_category' do
    @category = Category.where(permalink: params[:category]).first
    @parent_category = Category.where(permalink: params[:parent_category]).first

    @category.parent_category = @parent_category
    @category.save

    redirect to("/#{@category.permalink}")
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
