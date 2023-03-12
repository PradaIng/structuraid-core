require 'design_codes/utils/schema_definition'

module DesignCodes
  module Schemas
    module RC
      module Footings
        class PunchingShearCapacitySchema
          include DesignCodes::Utils::SchemaDefinition

          required_params %i[
            column_section_width
            column_section_height
            design_compression_strength
            critical_section_perimeter
            effective_height
            light_concrete_modification_factor
            column_location
          ]

          optional_params []
        end
      end
    end
  end
end
