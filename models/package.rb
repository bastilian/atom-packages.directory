# An Atom Package
class Package
  include NoBrainer::Document
  include Permalink

  field :name,
        index: true,
        uniq: true

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
        required: true
  field :keywords,
        index: true

  field :readme
  field :repository
  field :releases
  field :versions

  before_validation do
    write_attribute(:permalink, permalink_from(read_attribute(:name)))
  end

  default_scope do
    order_by(downloads: :desc)
  end

  class << self
    def from_data_json(json)
      new(build_package_attributes(json))
    end

    def build_package_attributes(package)
      {
        name: package['name'],
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
        return version_hash['keywords']
      end
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
end
