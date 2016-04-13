require 'active_support/inflections'
require 'json'
require 'sinatra/respond_with'
require 'controllers/application_controller'
require 'lib/resource_matcher'

class ResourcesController < ApplicationController
  register Sinatra::RespondWith
  respond_to :json, :html

  get ResourceMatcher.new do |resource_name, id|
    resource_object = Object.const_get(resource_name)

    if id
      resource = resource_object.where(resource_object.identifier => id).first.decorated
      template = "#{resource_name.downcase.pluralize}/show"
      locals_name = resource_name.downcase.singularize
    else
      resource = resource_object.all
      template = "#{resource_name.downcase.pluralize}/index"
      locals_name = resource_name.pluralize.downcase
    end

    respond_to do |format|
      format.html { erb template.to_sym, locals: { locals_name => resource } }
      format.json { resource.to_json }
    end
  end

  post ResourceMatcher.new do |resource, _|
    resource_object = Object.const_get(resource)
    resource = resource_object.create(JSON.parse(request.body.string))

    respond_to do |format|
      format.json { resource.to_json }
    end
  end

  put ResourceMatcher.new do |resource, id|
    resource_object = Object.const_get(resource)
    resource = resource_object.where(resource_object.identifier => id).first

    if resource
      resource.update(JSON.parse(request.body.string))

      status 200
    else
      status 404
    end
  end

  delete ResourceMatcher.new do |resource, id|
    resource_object = Object.const_get(resource)
    resource = resource_object.where(resource_object.identifier => id).first

    if resource
      resource.destroy
      status 200
    else
      status 404
    end
  end
end
