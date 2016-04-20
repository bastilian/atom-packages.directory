require 'lib/resource'
require 'decorators/category_decorator'

# A Category can have packages associated via PackageCateorisations and through keywords
class Category
  include Resource
  include NoBrainer::Document
  include Permalink

  identify_by :permalink
  decorate_with CategoryDecorator

  field :name,
        index: true,
        uniq: true,
        required: true

  field :description

  field :permalink,
        index: true,
        required: true,
        uniq: true

  field :packages_count,
        index: true,
        required: true,
        default: 0

  field :sub_categories_count,
        index: true,
        required: true,
        default: 0

  has_many :package_categorisations, dependent: :destroy
  has_many :packages, through: :package_categorisations

  belongs_to :parent_category,
             class_name: Category,
             index: true
  has_many :sub_categories,
           class_name: Category,
           foreign_key: :parent_category_id,
           scope: -> { order_by(packages_count: :desc) }

  before_validation do
    uniq_permalink_from(parent_category ? "#{parent_category.name} #{name}" : name)
  end

  default_scope do
    order_by(:name)
  end

  after_save do
    parent_category.update_counts if parent_category
  end

  scope :top, lambda {
    where(:parent_category.undefined => true)
      .where(:sub_categories_count.gt => 0)
  }

  scope :not_so_top, lambda {
    where(:parent_category.undefined => true)
      .where(sub_categories_count: 0)
  }

  def update_counts
    update(
      packages_count: packages.count + sub_categories.collect(&:packages_count).inject { |a, e| a + e }.to_i,
      sub_categories_count: sub_categories.count
    )
  end

  def parents
    return unless parent_category
    parent_categories = [parent_category]
    parent_categories << parent_category.parents
    parent_categories.flatten.compact
  end

  def merge_id=(id)
    merge(Category.find(id))
  end

  def merge(other_category)
    Category.where(parent_category_id: other_category.id).update_all(parent_category_id: id)
    PackageCategorisation.where(category_id: other_category.id).update_all(category_id: id)
    update_counts
    other_category.destroy
  end
end
