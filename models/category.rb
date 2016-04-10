# A Category can have packages associated via PackageCateorisations and through keywords
class Category
  include NoBrainer::Document
  include Permalink

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

  has_many :package_categorisations
  has_many :packages, through: :package_categorisations

  belongs_to :parent_category, class_name: Category
  has_many :sub_categories, class_name: Category, foreign_key: :parent_category_id

  before_validation do
    uniq_permalink_from(read_attribute(:name))
  end

  after_save do
    parent_category.update_counts if parent_category
  end

  scope :top, -> { where(:parent_category.undefined => true).where(:sub_categories_count.gt => 0) }

  default_scope do
    order_by(packages_count: :desc)
  end

  def parent_category=(category)
    self.parent_category_id = category.id
  end

  def parent_category
    return false unless parent_category_id
    @parent_category ||= Category.find(parent_category_id)
  end

  def update_counts
    write_attribute(:packages_count, packages.size)
    write_attribute(:sub_categories_count, sub_categories.count)
  end
end
