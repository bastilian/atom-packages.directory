# Associates Package and Category
class PackageCategorisation
  include NoBrainer::Document

  belongs_to :categorised_package, class_name: Package
  belongs_to :category
end
