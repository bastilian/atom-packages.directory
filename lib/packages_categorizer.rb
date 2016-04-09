module Packages
  # Takes packages in batches and categorises them based on their keywords
  class Categorizer
    attr_accessor :options

    DEFAULT_OPTIONS = {
      batch_size: 100
    }

    def initialize(options = {})
      self.options = DEFAULT_OPTIONS.merge(options)
    end

    def package_count
      @package_count ||= Package.all.count
    end

    def categorise_package(package)
      return unless package.keywords
      package.keywords.each do |keyword|
        next if keyword.blank?
        category_name = keyword.capitalize
        category = Category.where(name: category_name).first_or_create
        category.save!
        package.categorise(category)
      end
    end

    def categorise(batch: 1)
      puts "Working on batch ##{batch}"
      @packages = Package.limit(options[:batch_size]).skip(options[:batch_size] * (batch - 1))
      @packages.each do |package|
        categorise_package(package)
      end

      categorise(batch: batch + 1) unless options[:batch_size] * batch >= package_count
    end

    def start
      categorise
    end
  end
end
