module Packages
  # Takes packages in batches and categorises them based on their keywords
  class Categorizer
    attr_accessor :options

    DEFAULT_OPTIONS = {
      batch_size: 100
    }

    def initialize(options = {})
      self.options = DEFAULT_OPTIONS.merge(options)
      self.class.categorised = 0
      self.class.uncategorised = 0
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

          Category.where(permalink: permalink).first_or_create(name: category_name)
        end
      end

      def get_language(package)
        return unless package.permalink =~ /^language-/
        language_name = package.permalink.gsub(/^language-/, '')
        language = Category.where(permalink: language_name).first_or_create(name: language_name.tr('-', ' ').capitalize)
        language.save!

        language
      end

      def get_categories(package)
        categories = [*extract_keywords(package)]
        categories << get_language(package)

        categories.compact.uniq
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
