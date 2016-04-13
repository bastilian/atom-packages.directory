# Associates Package and Category
class PackageCategorisation
  include NoBrainer::Document

  belongs_to :package, index: true
  belongs_to :category, index: true

  after_destroy do
    category.destroy if category.packages.count == 0
  end

  after_save do
    category.update_counts
  end
end
