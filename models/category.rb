require 'lib/resource'
require 'decorators/category_decorator'

# A Category can have packages associated via PackageCateorisations and through keywords
class Category
  include Resource
  include Mongoid::Document
  include Permalink

  identify_by :permalink
  decorate_with CategoryDecorator

  field :name
  validates_uniqueness_of :name, scope: [:parent_category_id]
  validates_presence_of :name, :permalink, :sub_categories_count

  field :description

  field :permalink
  validates_uniqueness_of :permalink

  field :keywords, type: Array
  field :sub_categories_count,
        default: 0

  belongs_to :parent_category,
             class_name: 'Category',
             foreign_key: :parent_category_id
  has_many :sub_categories,
           class_name: 'Category',
           foreign_key: :parent_category_id

  before_validation do
    uniq_permalink_from(parent_category ? "#{parent_category.name} #{name}" : name)
  end

  after_save do
    parent_category.update_counts if parent_category
  end

  default_scope do
    order_by(name: :asc)
  end

  scope :top, lambda {
    where(parent_category_id: nil)
      .where(:sub_categories_count.gt => 0)
  }

  scope :not_so_top, lambda {
    where(parent_category_id: nil)
      .where(sub_categories_count: 0)
  }

  def update_counts
    update(
      sub_categories_count: sub_categories.count
    )
  end

  def packages_count
    Package.where(keywords: { '$in': own_keywords + child_keywords }).uniq.count
  end

  def parents
    return unless parent_category
    parent_categories = [parent_category]
    parent_categories << parent_category.parents
    parent_categories.flatten.compact
  end

  def packages
    return [] unless all_keywords
    pkgs = Package.where('$or': own_keywords.map { |keyword| { keywords: keyword } })
            .where('$or': [name: /(#{own_keywords.map { |keyword| Regexp.escape(keyword) }.join('|')})/])

    if sub_categories.count > 0
      pkgs = pkgs.where('$and': child_keywords.map { |keyword| { :keywords.ne => keyword } })
    end

    pkgs
  end

  def sibling_keywords
    return [] unless parent_category
    parent_category.sub_categories.where(:id.not => id).collect do |category|
      (category.own_keywords + child_keywords).uniq
    end
  end

  def own_keywords
    [(name).downcase] + (keywords || [])
  end

  def all_keywords
    own_keywords + (parents || []).collect(&:all_keywords).flatten
  end

  def child_keywords
    (sub_categories || []).collect { |c| [c.own_keywords, c.child_keywords] }.flatten
  end

  def self.keywords
    all.collect(&:own_keywords).flatten
  end
end
