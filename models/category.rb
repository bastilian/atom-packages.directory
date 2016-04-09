# A Category can have packages associated via PackageCateorisations and through keywords
class Category
  include NoBrainer::Document
  include Permalink

  field :name,
        index: true,
        uniq: true,
        required: true
  field :keywords, type: Array

  field :description
  field :permalink,
        index: true,
        required: true,
        uniq: true
  field :packages_count,
        index: true,
        required: true,
        default: 0

  has_many :package_categorisations
  has_many :categorised_packages, through: :package_categorisations

  field :parent_category_id
  has_many :sub_categories, class_name: Category, foreign_key: :parent_category_id

  before_validation do
    write_attribute(:packages_count, packages.size)
    uniq_permalink_from(read_attribute(:name))
  end

  scope :top, -> { where(parent_category_id: nil) }

  default_scope do
    order_by(:packages_count)
  end

  def packages
    @packages ||= [Package.where(:keywords.include => keywords), categorised_packages].flatten
  end

  def parent_category=(category)
    self.parent_category_id = category.id
  end

  def parent_category
    return false unless parent_category_id
    @parent_category ||= Category.find(parent_category_id)
  end
end
