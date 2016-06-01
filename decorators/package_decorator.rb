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
    readme.scan(/!\[.*?\]\((.*?)\)/).to_a.flatten.select { |image| image.match(/\.(?:jpg|jpeg|gif|png)$/) } unless readme.blank?
  end

  def humanized_name
    string = name
    string.gsub(/^(language|atom)-/, '')
    string.gsub(/-ui$/, '')
    string.tr('-', ' ')
    string.split(/(\W)/).map(&:capitalize).join
  end

  def github_repository
    repository['url'].scan(/github\.com\/(.*)$/).first.first
  end

  def add_keyword_url
    "https://github.com/#{github_repository}/edit/master/package.json"
  end

  def author
    @author = versions.collect { |v| v['author'] }.compact.first
    return unless @author
    @author = @author['name'] if @author['name']

    @author
  end
end
