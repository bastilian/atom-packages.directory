# Packages can relate to each other
#
#
#
#
class PackageRelationship
  include NoBrainer::Document

  belongs_to :package
  belongs_to :related_package

  field :relation,
        type: String,
        required: true,
        index: true
end
