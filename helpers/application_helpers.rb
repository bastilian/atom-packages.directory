module ApplicationHelpers
  def markdown(string)
    Kramdown::Document.new(string).to_html
  end
end
