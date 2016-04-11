require 'spec_helper'

describe PackageCategorisation, type: :model do
  let(:category) { FactoryGirl.create(:category) }
  let(:package)  { FactoryGirl.create(:package)  }

  it 'updates the categori\'s count' do
    expect do
      PackageCategorisation.create(package: package, category: category)
    end.to change(category, :packages_count).by(1)
  end

  it 'destroys the category if it has a count of 0 packages' do
    pc = PackageCategorisation.create(package: package, category: category)

    expect do
      category.packages.each(&:destroy)
      pc.destroy
    end.to change(Category, :count).by(-1)
  end
end
