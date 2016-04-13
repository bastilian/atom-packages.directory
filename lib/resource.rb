require 'active_support/concern'

module Resource
  extend ActiveSupport::Concern

  included do
    class_attribute :identifier
    class_attribute :decorator
    self.identifier = :id
  end

  def decorated
    if self.class.decorator
      self.class.decorator.new(self)
    else
      self
    end
  end

  class_methods do
    def identify_by(new_identifier)
      self.identifier = new_identifier
    end

    def decorate_with(new_decorator = nil)
      self.decorator = new_decorator || Object.const_get("#{name}Decorator")
    end
  end
end
