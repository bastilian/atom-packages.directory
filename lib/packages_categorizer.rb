require 'yaml'
module Packages
  # Takes packages in batches and categorises them based on their keywords
  class Categorizer
    attr_accessor :options,
                  :config,
                  :config_file

    DEFAULT_OPTIONS = {
      batch_size: 100
    }

    def initialize(options = {})
      self.options = DEFAULT_OPTIONS.merge(options)
      self.config_file = File.join(File.dirname(__FILE__), '../config.yml')
      self.config = YAML.load_file(config_file)
      self.class.categorised = 0
      self.class.uncategorised = 0

      build_category_tree
    end

    def build_category_tree(categories: config['base_categories'], parent_category: nil)
      categories.each do |category|
        name = category[0].dup
        sub_categories = category[1]
        new_category = Category.create(name: name, parent_category: parent_category)

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

    def start
      categorise
      puts "Categorised #{self.class.categorised} packages. (Uncategorised: #{self.class.uncategorised})"
      Category.not_so_top.where(packages_count: 1).destroy_all
    end

    class << self
      include Permalink
      attr_accessor :uncategorised,
                    :categorised

      def extract_keywords(package)
        return unless package.keywords
        package.keywords.compact.reject(&:empty?).map do |keyword|
          category_name = keyword.capitalize
          permalink = permalink_from(keyword)
          category(permalink: permalink, category_name: category_name)
        end
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
        language = category(permalink: language_name, category_name: language_name.tr('-', ' ').capitalize)

        unless language.parent_category
          language.parent_category = category(permalink: 'languages')
          language.save
        end

        language
      end

      def extract_categories_from_name(package)
        package.name.split('-').map do |name_part|
          category(permalink: permalink_from(name_part))
        end
      end

      def get_categories(package)
        categories = [*extract_keywords(package)]
        categories << get_language(package)
        categories << extract_categories_from_name(package)
        categories.flatten.compact.uniq
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
end
