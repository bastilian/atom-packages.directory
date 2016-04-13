require 'controllers/application_controller'

class CategoriesController < ApplicationController
  get '/category/:category' do
    category = Category.where(permalink: params[:category]).first

    erb :category, locals: { category: category }
  end
end
