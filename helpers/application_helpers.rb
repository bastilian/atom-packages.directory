module ApplicationHelpers
  include Sprockets::Helpers

  def markdown(string)
    Kramdown::Document.new(string).to_html
  end
end
