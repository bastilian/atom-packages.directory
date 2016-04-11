class PackageDecorator < Decorator
  def readme_html
    markdown(readme)
  end

  def humanized_name
    string = name
    string.gsub!(/^(language|atom)-/, '')
    string.gsub!(/-ui$/, '')
    string.tr!('-', ' ')
    string.split(/(\W)/).map(&:capitalize).join
  end
end
