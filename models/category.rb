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
  field :sub_categories_count,
        index: true,
        required: true,
        default: 0

  has_many :package_categorisations
  has_many :categorised_packages, through: :package_categorisations

  belongs_to :parent_category, class_name: Category
  has_many :sub_categories, class_name: Category, foreign_key: :parent_category_id

  before_validation do
    write_attribute(:packages_count, packages.size)

    if sub_categories.count > 0
      write_attribute(:sub_categories_count, sub_categories.count)
    end

    uniq_permalink_from(read_attribute(:name))
  end

  scope :top, -> { where(:sub_categories_count.gt => 0) }

  default_scope do
    order_by(packages_count: :desc)
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
