class CategoryDecorator < Decorator
  def image_path
    path = 'category/'
    path += "#{parent_category.permalink}-" if parent_category

    path + "#{permalink}.png"
  end
end
