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
      get "/package/#{resource.permalink}"

      expect(JSON.parse(last_response.body)['name']).to eq(resource.name)
    end
  end

  describe '# POST /resources' do
    it 'creates a new resource' do
      resource = FactoryGirl.build(:package)
      expect do
        post_json '/packages', resource.to_json
      end.to change(Package, :count).by(1)
    end
  end

  describe '# PUT /resource/id' do
    it 'updates a resource' do
      new_name = Faker::Name.name
      put "/package/#{resource.permalink}", { name: new_name }.to_json
      expect(resource.reload.name).to eq(new_name)
    end
  end

  describe '# DELETE /resource/id' do
    it 'destroys a resource' do
      expect do
        delete "/package/#{resource.permalink}"
      end.to change(Package, :count)
    end

    context 'when a resource does not exist' do
      it 'returns a 404' do
        delete '/package/random-id'

        expect(last_response.status).to eq(404)
      end
    end
  end
end
