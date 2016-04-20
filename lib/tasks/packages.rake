require 'lib/packages_downloader'
require 'lib/packages_importer'
require 'lib/packages_categorizer'

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

  desc 'Categorise packages'
  task :categorise do
    categorizer = Packages::Categorizer.new
    categorizer.start
  end

  desc 'Categorise packages while they are added or updated'
  task :categorise_live do
    categorizer = Packages::Categorizer.new
    categorizer.live
  end
end
