require 'lib/resource_matcher'
require 'json'

class ResourcesController < ApplicationController
  before do
    content_type :json
  end

  get ResourceMatcher.new do |resource_object, id|
    resource = Object.const_get(resource_object)
    (id ? resource.find(id) : resource.all).to_json
  end
end
