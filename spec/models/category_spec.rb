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
end
