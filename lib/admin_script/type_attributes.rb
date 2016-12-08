require 'active_support/concern'

# Rails5
# require 'active_model/type'

# TODO: Rails4
require 'active_record/type'

module AdminScript
  # Define method to cast value
  module TypeAttributes
    extend ActiveSupport::Concern

    module ClassMethods
      def type_attribute(name, cast_type)
        define_method name do
          value = instance_variable_get(:"@#{name}")
          # Rails5
          # ActiveModel::Type.lookup(cast_type).cast(value)
          # TODO: Rails4 http://stackoverflow.com/questions/29441796/manual-type-cast-in-rails-4-2
          ActiveRecord::Type.const_get(cast_type.to_s.camelize).new.send(:cast_value, value)
        end

        define_method "#{name}=" do |decibels|
          # Rails5
          # value = ActiveModel::Type.lookup(cast_type).cast(decibels)
          # TODO: Rails4 http://stackoverflow.com/questions/29441796/manual-type-cast-in-rails-4-2
          value = ActiveRecord::Type.const_get(cast_type.to_s.camelize).new.send(:cast_value, decibels)
          instance_variable_set(:"@#{name}", value)
        end
      end
    end
  end
end
