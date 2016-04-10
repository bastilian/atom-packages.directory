class PackagesController < ApplicationController
  get '/package/:permalink' do
    @package = PackageDecorator.new(Package.where(permalink: params[:permalink]).first)

    erb :package
  end
end
