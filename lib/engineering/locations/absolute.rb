require 'engineering/locations/base'

module Engineering
  module Locations
    class Absolute < Base
      attr_accessor :value_x, :value_y, :value_z

      def initialize(value_x:, value_y:, value_z:)
        @value_x = value_x.to_f
        @value_y = value_y.to_f
        @value_z = value_z.to_f
      end

      def to_a
        [@value_x, @value_y, @value_z]
      end
    end
  end
end
