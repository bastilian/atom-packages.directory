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

    def import_file(file)
      begin
        packages = JSON.parse(File.read(file))
        puts "#{packages.length} packages"
      rescue
        puts 'Failed'
        packages = []
      end

      packages.each do |package|
        next unless package && Package.where(name: package['name']).count == 0
        puts "Importing project: #{package['name']}"
        save_package(package)
      end
    end

    def save_package(package)
      pkg = Package.from_data_json(package)
      pkg.save!
    end

    def import
      Package.all.destroy_all
      files.each do |file|
        puts "Importing file: #{file}"
        import_file(file)
      end
    end

    def start
      import
    end
  end
end
