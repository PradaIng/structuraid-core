require 'spec_helper'
require 'engineering/vector'
require 'matrix'
require 'engineering/locations/relative'
require 'engineering/locations/absolute'

RSpec.describe Engineering::Vector do
  subject(:vector) { described_class.new(value_i:, value_j:, value_k:) }

  let(:value_i) { 3.0 }
  let(:value_j) { 4.0 }
  let(:value_k) { 0.0 }

  describe '#magnitude' do
    let(:expected_magnitude) { Math.sqrt(value_i**2 + value_j**2 + value_k**2) }

    it 'returns right magnitude' do
      expect(vector.magnitude).to be(expected_magnitude)
    end
  end

  describe '#direction' do
    let(:expected_unit_vector) do
      vector_magnitude = vector.magnitude

      [
        [value_i / vector_magnitude],
        [value_j / vector_magnitude],
        [value_k / vector_magnitude]
      ]
    end

    it 'returns an array' do
      expect(vector.direction).to be_an_instance_of(Matrix)
    end

    it 'returns right module' do
      expect(vector.direction.to_a).to match_array(expected_unit_vector)
    end
  end

  describe '#-' do
    let(:vector_to_substract) do
      described_class.new(
        value_i: value_i_expected,
        value_j: value_j_expected,
        value_k: value_k_expected
      )
    end
    let(:value_i_expected) { 15.0 }
    let(:value_j_expected) { 20.0 }
    let(:value_k_expected) { 0.0 }

    it 'returns a vector new instance' do
      expect(vector - vector_to_substract).to be_an_instance_of(described_class)
    end

    it 'returns a new vector isntance with right components values' do
      resulting_vector = vector.- vector_to_substract
      expected_magnitude = Math.sqrt(
        (value_i_expected - value_i)**2 + (value_j_expected - value_j)**2 + (value_k_expected - value_k)**2
      )

      expect(resulting_vector.magnitude).to be(expected_magnitude)
    end
  end

  describe '.with_value' do
    subject(:vector) { described_class.with_value(value:, direction:) }

    let(:value) { Math.sqrt(value_i**2 + value_j**2 + value_k**2) }
    let(:direction) do
      [
        value_i / value,
        value_j / value,
        value_k / value
      ]
    end

    it 'returns an instance of described class' do
      expect(vector).to be_an_instance_of(described_class)
    end

    it 'sets right value_i' do
      expect(vector.value_i).to be(value_i)
    end

    it 'sets right value_j' do
      expect(vector.value_j).to be(value_j)
    end

    it 'sets right value_k' do
      expect(vector.value_k).to be(value_k)
    end
  end

  describe '.based_on_location' do
    let(:relative_location) { Engineering::Locations::Relative.new(value_1:, value_2:, value_3:, origin:) }
    let(:value_1) { 3.0 }
    let(:value_2) { 0.0 }
    let(:value_3) { 4.0 }
    let(:origin) { Engineering::Locations::Absolute.new(value_x: 0.0, value_y: 0.0, value_z: 0.0) }

    let(:expected_magnitude) { Math.sqrt(value_1**2 + value_2**2 + value_3**2) }
    let(:expected_direction) do
      [
        [value_1 / expected_magnitude],
        [value_2 / expected_magnitude],
        [value_3 / expected_magnitude]
      ]
    end
    let(:vector) { described_class.based_on_location(location: relative_location) }

    it 'returns an instance of described class' do
      expect(vector).to be_an_instance_of(described_class)
    end

    it 'sets right value_i' do
      expect(vector.value_i).to be(value_1)
    end

    it 'sets right value_j' do
      expect(vector.value_j).to be(value_2)
    end

    it 'sets right value_k' do
      expect(vector.value_k).to be(value_3)
    end

    describe '#direction' do
      it 'returns an array' do
        expect(vector.direction).to be_an_instance_of(Matrix)
      end

      it 'returns right direction' do
        expect(vector.direction).to match_array(expected_direction)
      end
    end

    describe '#magnitude' do
      it 'returns right magnitude' do
        expect(vector.magnitude).to eq(expected_magnitude)
      end
    end
  end
end
