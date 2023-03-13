require 'engineering/locations/base'
require 'engineering/locations/absolute'
require 'matrix'

module Engineering
  module Locations
    class Relative < Base
      attr_accessor :value_1, :value_2, :value_3

      attr_reader :angle, :origin

      def self.from_location_to_location(from:, to:)
        array_location = (to.to_matrix - from.to_matrix).to_a

        new(
          value_1: array_location[0][0],
          value_2: array_location[1][0],
          value_3: array_location[2][0],
          origin: from
        )
      end

      def initialize(value_1:, value_2:, value_3:, origin:)
        @value_1 = value_1.to_f
        @value_2 = value_2.to_f
        @value_3 = value_3.to_f
        @origin = origin
        @angle = 0.0
      end

      def align_axis_1_with(vector:)
        @angle = Math.atan2(vector.value_j, vector.value_i)

        transformed = (transformer_array_global_to_relative * to_matrix).to_a
        @value_1 = transformed[0][0]
        @value_2 = transformed[1][0]
        @value_3 = transformed[2][0]

        self
      end

      def to_matrix
        Matrix.column_vector(
          [
            value_1,
            value_2,
            value_3
          ]
        )
      end

      def to_absolute_location
        transformed = transformer_array_relative_to_global * to_matrix
        @angle = 0.0

        initialize_absolute_from_array(matrix: transformed + origin.to_matrix)
      end

      def to_vector
        Engineering::Vector.based_on_location(location: self)
      end

      private

      def transformer_array_global_to_relative
        Matrix[
          [Math.cos(angle), Math.sin(angle), 0],
          [-Math.sin(angle), Math.cos(angle), 0],
          [0, 0, 1]
        ]
      end

      def transformer_array_relative_to_global
        Matrix[
          [Math.cos(angle), -Math.sin(angle), 0],
          [Math.sin(angle), Math.cos(angle), 0],
          [0, 0, 1]
        ]
      end

      def initialize_absolute_from_array(matrix:)
        Engineering::Locations::Absolute.new(
          value_x: matrix.to_a[0][0],
          value_y: matrix.to_a[1][0],
          value_z: matrix.to_a[2][0]
        )
      end
    end
  end
end
