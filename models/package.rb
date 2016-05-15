require 'lib/resource'
require 'decorators/package_decorator'

# An Atom Package
class Package
  include Resource
  include Mongoid::Document
  include Permalink

  identify_by :permalink
  decorate_with PackageDecorator

  field :name
  field :permalink
  field :description
  field :downloads, default: 0
  field :stargazers_count, default: 0
  field :keywords, type: Array
  field :readme
  field :repository
  field :releases
  field :versions

  validates_uniqueness_of :name, :permalink
  validates_presence_of :downloads, :stargazers_count, :permalink

  before_validation do
    downcase_keywords
    uniq_permalink_from(read_attribute(:name))
  end

  after_save :update_counts

  def update_counts
    categories.each(&:update_counts)
  end

  def downcase_keywords
    self.keywords = keywords.each(&:downcase!) if keywords
  end

  default_scope do
    order_by(downloads: :desc)
  end

  scope :top, -> { limit(10) }

  def categories
    return [] unless keywords
    Category.where(keywords: { '$in': keywords })
  end

  class << self
    def categorised_packages_count
      @categorised_packages_count ||= Package.where(keywords: { '$in': Category.keywords }).count
    end

    def packages_count
      @packages_count ||= Package.count
    end

    def from_data_json(json)
      new(build_package_attributes(json))
    end

    def build_package_attributes(package)
      {
        name: package['name'],
        description: (package['metadata'] ? package['metadata']['description'] : ''),
        readme: package['readme'],
        repository: package['repository'],
        downloads: package['downloads'],
        stargazers_count: package['stargazers_count'],
        releases: package['releases'],
        keywords: extract_keywords(package['versions'])
      }
    end

    def extract_keywords(versions)
      versions.values.collect do |version_hash|
        return version_hash['keywords'] if version_hash['keywords']
      end.flatten.compact
    end

    def extract_versions(versions)
      new_versions = {}

      versions.values.each do |version_hash|
        v = version_hash['version']
        new_versions[v] = version_hash
      end

      new_versions
    end
  end

  def self.keywords
    all.collect(&:keywords).flatten.compact.each(&:downcase).uniq
  end
end
