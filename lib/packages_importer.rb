module Packages
  # Imports packages from a data directory created by Packages::Downloader
  class Importer
    attr_accessor :options

    DEFAULT_OPTIONS = {
      directory: File.join(Dir.pwd, 'data')
    }

    def initialize(options = {})
      self.options = DEFAULT_OPTIONS.merge(options)
    end

    def glob
      "#{options[:directory]}/**/*.json"
    end

    def files
      Dir[glob]
    end

    def packages_from_file(file)
      packages = JSON.parse(File.read(file))
      puts "#{packages.length} packages"

      packages
    rescue
      puts 'Failed'
      []
    end

    def import_package(package_json)
      package = Package.where(name: package_json['name']).first
      package_attributes = Package.build_package_attributes(package_json)
      if package
        puts "Updating #{package.name}"
        package.update(package_attributes)
      else
        puts "Adding #{package_json['name']}"
        Package.create(package_attributes)
      end
    end

    def import_file(file)
      packages_from_file(file).each do |package_json|
        next unless package_json
        import_package(package_json)
      end
    end

    def import
      files.each do |file|
        puts "Importing file: #{file}"
        import_file(file)
      end
    end

    def start
      Package.delete_all

      import
    end
  end
end
