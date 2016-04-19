require 'spec_helper'
require 'lib/packages_categorizer'

describe Packages::Categorizer do
  subject { Packages::Categorizer.new }
  let(:package) { FactoryGirl.create(:package) }

  before do
    package.save
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
      expect(Packages::Categorizer.extract_keywords(package).sample.class).to eq(Category)
    end
  end

  describe '.get_language' do
    context "the package is named with 'language-LANG'" do
      let(:package) { FactoryGirl.create(:package, name: 'language-LANG') }

      it 'returns a category for the language' do
        expect(Packages::Categorizer.get_language(package).name).to eq('Lang')
      end
    end

    context 'the package is not named as a language' do
      it 'returns nil' do
        expect(Packages::Categorizer.get_language(package)).to eq(nil)
      end
    end

    describe '.categorise_package' do
      it 'adds a categories for a package' do
        expect do
          Packages::Categorizer.categorise_package(package)
        end.to change(PackageCategorisation, :count)
      end
    end
  end
end
