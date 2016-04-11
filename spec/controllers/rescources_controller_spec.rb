require 'spec_helper'

describe ResourcesController, type: :controller do
  let(:resource) { FactoryGirl.create(:package) }

  before do
    resource.save
  end

  describe '# GET /resources' do
    it 'returns a json array with results' do
      get '/packages'

      expect(last_response.content_type).to eq('application/json')
      expect(JSON.parse(last_response.body).size).to be > 0
    end
  end

  describe '# GET /resource/id' do
    it 'returns a json object for the resource' do
      get "/package/#{resource.id}"

      expect(JSON.parse(last_response.body)['name']).to eq(resource.name)
    end
  end
end
