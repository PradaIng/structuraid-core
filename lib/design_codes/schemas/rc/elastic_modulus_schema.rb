require 'design_codes/utils/schema_definition'

module DesignCodes
  module Schemas
    module RC
      class ElasticModulusSchema
        include DesignCodes::Utils::SchemaDefinition

        required_params %i[design_compression_strength]
        optional_params []
      end
    end
  end
end
