require 'spec_helper'

describe Category, type: :model do
  subject { FactoryGirl.create(:category) }

  describe '#update_counts' do
    context 'when a package is categorised' do
      it 'is called and updates the packages count' do
        expect do
          FactoryGirl.create(:package_categorisation, category: subject)
        end.to change(subject, :packages_count).by(1)
      end
    end

    context 'when a subcategory is added' do
      it 'is called and updates the sub_categories_count' do
        expect do
          FactoryGirl.create(:category, parent_category: subject)
        end.to change(subject, :sub_categories_count).by(1)
      end
    end
  end

  describe '#merge' do
    let(:other_category) { FactoryGirl.create(:category) }
    let(:package) { FactoryGirl.create(:package) }
    let(:package_categorisation) { FactoryGirl.create(:package_categorisation, category: other_category, package: package) }

    before do
      package.save
      subject.save
      other_category.save
      package_categorisation.save
    end

    it 'moves packages from the given category in' do
      subject.merge(other_category)
      expect(package.categories).to include(subject)
    end

    it 'destroys the other category' do
      expect do
        subject.merge(other_category)
      end.to change(Category, :count).by(-1)
    end

    it 'updates all subcategories to link to the new one' do
      sub_category = FactoryGirl.create(:category, parent_category_id: other_category.id)
      sub_category.save

      subject.merge(other_category)
      expect(sub_category.reload.parent_category).to eq(subject)
    end
  end
end
