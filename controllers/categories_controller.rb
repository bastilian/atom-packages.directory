class CategoriesController < ApplicationController
  get '/category/:category' do
    @category = Category.where(permalink: params[:category]).first

    erb :category
  end

  post '/category' do
    @category = Category.where(name: params[:name]).first_or_create(description: params[:description])

    erb :category
  end

  get '/subcategorise/:category/as/:parent_category' do
    @category = Category.where(permalink: params[:category]).first
    @parent_category = Category.where(permalink: params[:parent_category]).first

    @category.parent_category = @parent_category
    @category.save

    redirect to("/category/#{@category.permalink}")
  end
end
