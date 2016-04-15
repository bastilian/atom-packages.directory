module Packages
  # Downlods packages from an Atom.io package repository
  class Downloader
    attr_accessor :options

    DEFAULT_OPTIONS = {
      url: ENV['ATOMIO_API'] || 'https://atom.io/',
      max_pages: 190,
      directory: File.join(Dir.pwd, 'data')
    }

    def initialize(options = {})
      self.options = DEFAULT_OPTIONS.merge(options)
    end

    def client
      @client ||= Faraday.new(url: options[:url]) do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.headers['Content-Type'] = 'application/json; charset=utf-8'
      end
    end

    def download(page: 1, max_pages: options[:max_pages])
      puts "Downloading page ##{page}"
      response = client.get do |req|
        req.url '/api/packages', (page > 1 ? { page: page } : {})
      end
      save(json: response.body, page: page)
      download(page: page.next) unless page == max_pages
    end

    def save(json:, page: 1)
      puts "Saving page ##{page}"
      File.open(File.join(options[:directory], "page_#{page}.json"), 'w') do |f|
        f.write(json)
      end
    end

    def start
      download(page: 1)
    end
  end
end
