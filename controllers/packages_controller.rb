class PackagesController < ApplicationController
  get '/package/:permalink' do
    @package = Package.where(permalink: params[:permalink]).first

    erb :package
  end
end
