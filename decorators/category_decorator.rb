class CategoryDecorator < Decorator
  def image_path
    "category/#{permalink}.png"
  end
end
