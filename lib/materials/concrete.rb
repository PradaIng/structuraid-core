require 'materials/base'

module Materials
  class Concrete < Base
    attr_accessor :elastic_module, :design_compression_strength, :specific_weight

    def initialize(elastic_module:, design_compression_strength:, specific_weight:)
      @elastic_module = elastic_module.to_f
      @design_compression_strength = design_compression_strength.to_f
      @specific_weight = specific_weight.to_f
    end
  end
end
