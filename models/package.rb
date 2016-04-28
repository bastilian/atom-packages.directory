require 'lib/resource'
require 'decorators/package_decorator'

# An Atom Package
class Package
  include Resource
  include NoBrainer::Document
  include Permalink

  identify_by :permalink
  decorate_with PackageDecorator

  field :name,
        index: true,
        uniq: true

  field :description

  field :downloads,
        index: true,
        required: true,
        default: 0

  field :stargazers_count,
        index: true,
        required: true,
        default: 0

  field :permalink,
        index: true,
        required: true,
        uniq: true

  field :keywords,
        index: true,
        type: Array

  field :readme
  field :repository
  field :releases
  field :versions

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
    Category.where(_or: keywords.map { |keyword| { :keywords.include => keyword } })
  end

  class << self
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
        keywords: extract_keywords(package['versions']),
        versions: extract_versions(package['versions'])
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
        new_versions[v] = {}
      end

      new_versions
    end
  end

  def self.keywords
    all.collect(&:keywords).flatten.compact.each(&:downcase).uniq
  end
end
