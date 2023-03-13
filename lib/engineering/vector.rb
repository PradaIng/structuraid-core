require 'engineering/base'

module Engineering
  class Vector < Base
    attr_accessor :value_i, :value_j, :value_k

    class << self
      def based_on_location(location:)
        initialize_from_array(matrix: location.to_matrix)
      end

      def with_value(value:, direction:)
        new(
          value_i: value.to_f * direction[0],
          value_j: value.to_f * direction[1],
          value_k: value.to_f * direction[2]
        )
      end

      def initialize_from_array(matrix:)
        new(
          value_i: matrix.to_a[0][0],
          value_j: matrix.to_a[1][0],
          value_k: matrix.to_a[2][0]
        )
      end
    end

    def initialize(value_i:, value_j:, value_k:)
      @value_i = value_i.to_f
      @value_j = value_j.to_f
      @value_k = value_k.to_f
    end

    def magnitude
      Math.sqrt(value_i**2 + value_j**2 + value_k**2)
    end

    def direction
      vector_magnitude = magnitude

      Matrix.column_vector(
        [
          @value_i / vector_magnitude,
          @value_j / vector_magnitude,
          @value_k / vector_magnitude
        ]
      )
    end

    def -(other)
      Engineering::Vector.initialize_from_array(matrix: to_matrix - other.to_matrix)
    end

    def to_matrix
      Matrix.column_vector(
        [
          value_i,
          value_j,
          value_k
        ]
      )
    end
  end
end
