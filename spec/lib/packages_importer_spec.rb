require 'spec_helper'
require 'lib/packages_importer'

describe Packages::Importer do
  let(:options) { { directory: File.join(File.dirname(__FILE__), '../fixtures') } }
  subject { Packages::Importer.new(options) }

  describe '#glob' do
    it 'returns a glob for json files in the set directory' do
      expect(subject.glob).to eq("#{options[:directory]}/**/*.json")
    end
  end

  describe '#files' do
    it 'returns an array of files' do
      expect(subject.files).to eq(Dir["#{options[:directory]}/**/*.json"])
    end
  end

  describe '#import_file' do
    context 'the file is readable json' do
      let(:file) { subject.files.sample }

      it 'parses the json' do
        expect(JSON).to receive(:parse).and_call_original.at_least(1).times
        subject.import_file(file)
      end

      it 'imports the projects into the database' do
        expect do
          subject.import_file(file)
        end.to change(Package, :count).by(30)
      end
    end
  end
end
