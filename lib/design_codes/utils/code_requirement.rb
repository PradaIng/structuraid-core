module DesignCodes
  module Utils
    module CodeRequirement
      def self.included(base)
        base.class_eval do
          extend ClassMethods

          attr_reader :params
        end
      end

      def initialize(params)
        @params = params
      end

      module ClassMethods
        def call(params = {})
          schema_klass.validate!(params)
          sanitized_params = schema_klass.structurize(params)
          sanitized_params.members.each do |param_name|
            define_method(param_name) { sanitized_params[param_name] }
          end

          obj = new(sanitized_params)
          obj.call
        end

        def schema_klass
          @schema_klass
        end

        private

        def use_schema(schema_klass)
          @schema_klass = schema_klass
        end
      end
    end
  end
end
