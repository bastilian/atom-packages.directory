class PackageCategorisationsController < ApplicationController
  get '/categorise/:package/as/:category' do
    package = Package.where(permalink: params[:package]).first
    category = Category.where(permalink: params[:category]).first_or_create(name: params[:category].capitalize)
    category.save
    package.categorise(category)

    redirect to("/package/#{package.permalink}")
  end

  get '/uncategorise/:package/from/:category' do
    package = Package.where(permalink: params[:package]).first
    category = Category.where(permalink: params[:category]).first
    package.uncategorise(category)

    redirect to("/package/#{package.permalink}")
  end
end
