require 'lib/resource_matcher'
require 'json'

class ResourcesController < ApplicationController
  before do
    content_type :json
  end

  get ResourceMatcher.new do |resource, id|
    resource_object = Object.const_get(resource)
    (id ? resource_object.find?(id) : resource_object.all).to_json
  end

  delete ResourceMatcher.new do |resource, id|
    resource_object = Object.const_get(resource)
    resource = resource_object.find?(id)
    if resource
      resource.destroy
      status 200
    else
      status 404
    end
  end
end
