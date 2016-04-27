require 'lib/packages_downloader'
require 'lib/packages_importer'
require 'lib/categories_creator'

namespace :packages do
  desc 'Download latest package data from api.atom.io'
  task :download do
    downloader = Packages::Downloader.new
    downloader.start
  end

  desc 'Import packages from downloaded data'
  task :import do
    importer = Packages::Importer.new
    importer.start
  end
end

namespace :categories do
  desc 'Create categories based on configuration'
  task :create do
    Categories::Creator.new
  end
end
