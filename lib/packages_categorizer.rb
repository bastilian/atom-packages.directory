require 'yaml'
module Packages
  # Takes packages in batches and categorises them based on their keywords
  class Categorizer
    include Permalink
    attr_accessor :options,
                  :config,
                  :config_file,
                  :uncategorised,
                  :categorised

    DEFAULT_OPTIONS = {
      batch_size: 100
    }

    def initialize(options = {})
      self.options = DEFAULT_OPTIONS.merge(options)
      self.config_file = File.join(File.dirname(__FILE__), '../config.yml')
      self.config = YAML.load_file(config_file)
      self.categorised = 0
      self.uncategorised = 0

      build_category_tree
    end

    def build_category_tree(categories: config['base_categories'], parent_category: nil)
      categories.each do |category|
        name = category[0].dup
        sub_categories = category[1]
        new_category = Category.where(name: name, parent_category: parent_category).first_or_create

        if sub_categories
          build_category_tree(categories: category[1], parent_category: new_category)
        end
      end
    end

    def package_count
      @package_count ||= Package.all.count
    end

    def categorise(batch: 1)
      puts "Working on batch ##{batch}"

      Package.limit(options[:batch_size]).skip(options[:batch_size] * (batch - 1)).each do |package|
        self.class.categorise_package(package)
      end

      categorise(batch: batch + 1) unless options[:batch_size] * batch >= package_count
    end

    def live
      Package.all.raw.changes.each do |change|
        if change['new_val']['id']
          categorise_package(Package.find(change['new_val']['id']))
        end
      end
    end

    def start
      categorise
      puts "Categorised #{categorised} packages. (Uncategorised: #{uncategorised})"
      Category.not_so_top.where(packages_count: 1).destroy_all
    end

    def extract_keywords(package)
      return unless package.keywords
      keywords = package.keywords.compact.reject(&:empty?)
      keywords.map do |keyword|
        keyword = alias_for(keyword)
        category_from_keyword(keyword)
      end
    end

    def category_from_keyword(keyword)
      keyword_alias = alias_for(keyword)
      if keyword_alias
        category(permalink: keyword_alias)
      else
        category_name = keyword.capitalize
        permalink = permalink_from(keyword)
        category(permalink: permalink, category_name: category_name)
      end
    end

    def alias_for(keyword)
      config['keywords']['aliases'][keyword] || keyword
    end

    def category(permalink:, category_name: nil)
      criteria = Category.where(permalink: permalink)
      if category_name
        criteria.first_or_create(name: category_name)
      else
        criteria.first
      end
    end

    def get_language(package)
      return unless package.permalink =~ /^language-/
      language_name = package.permalink.gsub(/^language-/, '')
      language = Category.where(permalink: 'languages-' + language_name).first

      unless language
        puts "Creating Language category for #{language_name}"
        language = Category.create(name: language_name.tr('-', ' ').capitalize,
                                   parent_category: category(permalink: 'languages'))
      end

      language
    end

    def extract_categories_from_name(package)
      package.name.split('-').map do |name_part|
        name_part = alias_for(name_part)
        category(permalink: permalink_from(name_part))
      end
    end

    def remove_parents(categories)
      parents = categories.collect(&:parents).flatten.compact.uniq
      if parents.length > 0
        puts "Removing #{parents.collect(&:name).join(',')}"
      end
      categories - parents
    end

    def get_categories(package)
      categories = [*extract_keywords(package)]
      categories << get_language(package)
      categories << extract_categories_from_name(package)
      remove_parents(categories.flatten.compact).uniq
    end

    def categorise_package(package)
      categories = get_categories(package)

      if !categories.empty?
        categories.each do |category|
          puts "Categorising #{package.name} as #{category.name}"
          package.categorise(category)
        end

        self.categorised += 1
      else
        puts "Unable to categorise #{package.name}"
        self.uncategorised += 1
      end
    end
  end
end
