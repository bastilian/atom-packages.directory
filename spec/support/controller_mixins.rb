module ControllerMixins
  include Rack::Test::Methods
  def app
    described_class
  end

  def post_json(uri, json)
    post uri, json, 'CONTENT_TYPE' => 'application/json'
  end
end
