class CategoryDecorator < Decorator
  def image_path
    path = 'category/'
    path += "#{parent_category.permalink}-" if parent_category
    path += "#{permalink}.png"

    file = File.exist?(File.join(File.dirname(__FILE__), "../assets/images/#{path}"))

    file ? path : nil
  end
end
