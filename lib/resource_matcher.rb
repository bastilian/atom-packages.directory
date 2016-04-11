require 'active_support/inflections'

class ResourceMatcher
  Match = Struct.new(:captures)

  def initialize
    @captures = Match.new([])
    @models   = Object.constants.select do |object|
      (Object.const_get(object).try(:ancestors) || []).include?(NoBrainer::Document)
    end
  end

  def model?(resource_name)
    resource_name = resource_name.split('-').map(&:capitalize).join
    @models.include?(resource_name.to_sym)
  end

  def collection_requrest?(resource_name)
    resource_name.pluralize == resource_name
  end

  def process_request(path)
    resource_name, id = path.split('/')[1..-1]
    resource_name = resource_name.singularize if collection_requrest?(resource_name)

    return unless model?(resource_name)
    @captures.captures << resource_name.capitalize
    @captures.captures << id
  end

  def match(path)
    @captures.captures = []
    process_request(path)
    @captures if @captures.captures.size > 0
  end
end
