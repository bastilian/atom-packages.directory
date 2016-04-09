# Associates Package and Category
class PackageCategorisation
  include NoBrainer::Document

  belongs_to :categorised_package, class_name: Package
  belongs_to :category

  before_destroy do
    category.destroy if category.packages.count == 0
  end
end
