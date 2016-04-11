class CategoriesController < ApplicationController
  get '/category/:category' do
    category = Category.where(permalink: params[:category]).first

    erb :category, locals: { category: category }
  end

  post '/category' do
    category = Category.where(name: params[:name]).first_or_create(description: params[:description])

    erb :category, locals: { category: category }
  end

  get '/subcategorise/:category/as/:parent_category' do
    category = Category.where(permalink: params[:category]).first
    category.update(
      parent_category: Category.where(permalink: params[:parent_category]).first
    )

    redirect to("/category/#{category.permalink}")
  end
end
