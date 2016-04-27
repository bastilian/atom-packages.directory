require 'spec_helper'

describe Category, type: :model do
  subject { FactoryGirl.create(:category) }

  describe 'permalink' do
    context 'when a parent_category' do
      let(:parent) { FactoryGirl.create(:category) }
      subject { FactoryGirl.create(:category, parent_category: parent) }

      it 'will be added to the permalink' do
        expect(subject.permalink).to match(/^#{parent.permalink}/)
      end
    end
  end

  describe '#all_keywords' do
    let(:parent) { FactoryGirl.create(:category) }
    subject { FactoryGirl.create(:category, parent_category: parent) }

    it 'returns lowercase name, keywords and parents keywords' do
      expect(subject.all_keywords).to eq([subject.name.downcase] + subject.keywords + parent.all_keywords)
    end
  end

  describe '#packages' do
    let(:package) { FactoryGirl.create(:package, keywords: [subject.keywords.sample]) }

    it 'returns matching packages' do
      package.save
      expect(subject.packages).to include(package)
    end
  end

  describe '#update_counts' do
    context 'when a package is categorised' do
      let(:keyword) { Faker::Lorem.word }
      let(:package) { FactoryGirl.create(:package) }
      subject { FactoryGirl.create(:category, keywords: [keyword]) }

      it 'is called and updates the packages count' do
        expect do
          subject.save
          package.keywords << keyword
          package.save!
          subject.reload
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

  describe '#decorate_with' do
    it 'sets the decorator class' do
      subject.class.send(:decorate_with, 'NewDecorator')
      expect(subject.class.decorator).to eq('NewDecorator')
    end

    it 'defaults to class + Decorator' do
      subject.class.send(:decorate_with, nil)
      expect(subject.class.decorator).to eq(CategoryDecorator)
    end
  end
end
