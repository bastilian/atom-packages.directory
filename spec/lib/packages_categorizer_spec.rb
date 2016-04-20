require 'spec_helper'
require 'lib/packages_categorizer'

describe Packages::Categorizer do
  subject { Packages::Categorizer.new }
  let(:package) { FactoryGirl.create(:package) }

  before do
    allow(subject).to receive(:config).and_return({})
    package.save
  end

  describe '#categorise_package' do
    before do
      Category.destroy_all
    end

    it 'creates categories based on keywords' do
      expect do
        subject.categorise_package(package)
      end.to change(Category, :count).by(package.keywords.size)
    end

    it 'assigns the category' do
      expect do
        subject.categorise_package(package)
      end.to change(PackageCategorisation, :count).by(package.keywords.size)
    end

    context 'when a category for a keyword exists' do
      let(:keyword)  { Faker::Lorem.word }
      let(:category) { FactoryGirl.create(:category, name: keyword.capitalize) }

      before do
        category.save
        package.keywords << keyword
        package.save
      end

      it 'does not create a new one' do
        expect do
          subject.categorise_package(package)
        end.to change(Category, :count).by(package.keywords.size - 1)
      end

      it 'still assigns the category' do
        expect do
          subject.categorise_package(package)
        end.to change(PackageCategorisation, :count).by(package.keywords.size)
      end
    end

    context 'when the packages is a language-LANG package' do
      context 'and a category does not exist' do
        before do
          Category.create(name: 'Languages')
          package.update(name: 'language-LANG')
        end

        it 'creates one' do
          expect do
            subject.categorise_package(package)
          end.to change(Category, :count).by(package.keywords.size + 1)
        end
      end
    end

    context 'when the package contains existing categories in it\'s name' do
      before do
        Category.create(name: 'Syntax')
        package.update(name: 'ultimate-syntax-themes')
      end

      it 'adds them as well' do
        expect do
          subject.categorise_package(package)
        end.to change(PackageCategorisation, :count).by(package.keywords.size + 1)
      end
    end

    context 'when the package keywords contain sub and parent categories' do
      before do
        themes = FactoryGirl.create(:category, name: 'Themes')
        FactoryGirl.create(:category, name: 'Syntax', parent_category: themes)
        package.update(name: 'ultimate-syntax-themes')
      end

      it 'only adds the sub_category' do
        expect do
          subject.categorise_package(package)
        end.to change(PackageCategorisation, :count).by(package.keywords.size + 1)
      end
    end
  end

  describe '#package_count' do
    it 'returns the count of packages' do
      expect(subject.package_count).to eq(1)
    end
  end

  describe '#categorise' do
    context 'when no batch_size is set' do
      it 'retrives packages with a limit calculated from the default' do
        expect(Package).to receive(:limit).with(100).and_call_original
        subject.categorise
      end
    end

    context 'when a batch is given' do
      it 'skips batch_size times the batch' do
        expect_any_instance_of(NoBrainer::Criteria).to receive(:skip).with(100).and_call_original
        subject.categorise(batch: 2)
      end
    end
  end

  describe '.extract_keywords' do
    it 'returns an array of categories' do
      expect(subject.extract_keywords(package).sample.class).to eq(Category)
    end
  end

  describe '.get_language' do
    context "the package is named with 'language-LANG'" do
      let(:package) { FactoryGirl.create(:package, name: 'language-LANG') }

      it 'returns a category for the language' do
        expect(subject.get_language(package).name).to eq('Lang')
      end
    end

    context 'the package is not named as a language' do
      it 'returns nil' do
        expect(subject.get_language(package)).to eq(nil)
      end
    end
  end
end
