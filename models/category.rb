# A Category can have packages associated via PackageCateorisations and through keywords
class Category
  include NoBrainer::Document

  field :name, index: true, uniq: true
  field :keywords, type: Array

  field :description
  field :permalink, index: true

  has_many :package_categorisations
  has_many :categoriesed_packages, through: :package_categorisations

  field :parent_category_id
  has_many :sub_categories, class_name: Category, foreign_key: :parent_category_id

  before_validation do
    write_attribute(:permalink, permalink_from(read_attribute(:name)))
  end

  def packages
    @packages ||= [Package.where(:keywords.include => keywords), categoriesed_packages].flatten
  end
end
