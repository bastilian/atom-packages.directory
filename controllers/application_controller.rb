require 'lib/environment'
require 'sprockets'
require 'sprockets-helpers'
require 'compass'

class ApplicationController < Sinatra::Base
  helpers ApplicationHelpers
  set :sprockets, Sprockets::Environment.new(root)

  # Partials support for views
  register Sinatra::Partial

  set :partial_template_engine, :erb
  set :views, File.join(File.dirname(__FILE__), '../views')

  before do
    content_type 'text/html'
  end

  configure do
    enable :logging
    use Rack::CommonLogger, LOG_FILE

    %w(javascripts stylesheets images).each do |type|
      sprockets.append_path File.join(root, "../assets/#{type}")
    end
    sprockets.append_path File.join(root, '../assets/javascripts/views')
    sprockets.append_path File.join(root, '../assets', 'javascripts', 'bower_components')

    Sprockets::Helpers.configure do |config|
      config.environment = sprockets
      config.prefix      = '/assets'
    end
  end

  get '/' do
    @categorised_packages_count = Package.where(_or: Category.keywords.map { |keyword| :keywords.include(keyword) }).count
    @packages_count = Package.count

    erb :index, locals: { top_categories: Category.top,
                          not_so_top_categories: Category.not_so_top }
  end

  get "#{Sprockets::Helpers.prefix}/*" do |path|
    env_sprockets = request.env.dup
    env_sprockets['PATH_INFO'] = path
    settings.sprockets.call env_sprockets
  end

  not_found do
    if request.env['PATH_INFO'].match(/\.\S{1,5}$/)
      content_type :png
      status 200
      File.read(File.join('assets', 'images', 'pixel.png'))
    end
  end
end
