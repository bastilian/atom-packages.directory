class PackageDecorator < Decorator
  def readme_html
    if readme
      markdown(readme)
    else
      markdown("_No README_")
    end
  end

  def readme_images
    unless readme.blank?
      readme.scan(/!\[.*\]\((.+\.+\S{1,5})\)$/).to_a.flatten
    else
      []
    end
  end

  def humanized_name
    string = name
    string.gsub!(/^(language|atom)-/, '')
    string.gsub!(/-ui$/, '')
    string.tr!('-', ' ')
    string.split(/(\W)/).map(&:capitalize).join
  end
end
