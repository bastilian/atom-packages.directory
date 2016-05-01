class PackageDecorator < Decorator
  def description_html
    if !description.blank?
      markdown(description)
    else
      markdown('_No description_')
    end
  end

  def readme_html
    if !readme.blank?
      markdown(readme)
    else
      markdown('_No README_')
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

  def github_repository
    repository['url'].scan(/github\.com\/(.*)$/).first.first
  end

  def add_keyword_url
    "http://github.com/#{github_repository}/edit/master/package.json"
  end
end
