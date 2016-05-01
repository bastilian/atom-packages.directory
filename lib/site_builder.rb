require 'fileutils'

class SiteBuilder
  attr_accessor :options

  DEFAULT_OPTIONS = {
    output_directory: File.join(Dir.pwd, 'build')
  }

  def initialize(options = {})
    self.options = DEFAULT_OPTIONS.merge(options)
  end

  def clean
    system("rm -R #{options[:output_directory]}/* && mkdir -p #{options[:output_directory]}")
  end

  def indexify(file)
    directory = File.dirname(file)
    name = File.basename(file, '.html')
    return if name == 'index'
    new_directory = File.join(directory, name)
    index_file = File.join(new_directory, 'index.html')

    FileUtils.mkdir_p(new_directory)
    FileUtils.mv(file, index_file)
  end

  def post_process(directory = options[:output_directory])
    Dir[File.join(directory, '**', '**', '*.html')].each do |file|
      indexify(file)
    end
  end

  def get(url = options[:url])
    system("wget -nH --recursive --no-clobber \
                 --page-requisites --html-extension \
                 --no-parent --adjust-extension \
                 --directory-prefix #{options[:output_directory]} \
                 #{url}")
  end

  def start
    clean
    get
    post_process
  end
end
