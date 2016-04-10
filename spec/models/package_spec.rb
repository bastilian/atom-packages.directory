require 'spec_helper'

describe Package, type: :model do
  subject { FactoryGirl.create(:package) }
  let(:category) { FactoryGirl.create(:category) }

  describe '#categorise' do
    it 'adds a category to categories' do
      expect do
        subject.categorise(category)
      end.to change(PackageCategorisation, :count).by(1)
    end
  end

  describe '#uncategorise' do
    before do
      subject.categorise(category)
    end

    it 'removes a category from categories' do
      expect do
        subject.uncategorise(category)
      end.to change(PackageCategorisation, :count).by(-1)
    end
  end
end
