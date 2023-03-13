require 'spec_helper'
require 'engineering/locations/relative'
require 'engineering/locations/absolute'
require 'matrix'
require 'engineering/vector'

RSpec.describe Engineering::Locations::Relative do
  subject(:relative) { described_class.new(value_1:, value_2:, value_3:, origin:) }

  let(:value_1) { 3.0 }
  let(:value_2) { 4.0 }
  let(:value_3) { 6.0 }
  let(:origin) { Engineering::Locations::Absolute.new(value_x: 10.0, value_y: 15.0, value_z: 3.0) }

  describe '.from_location_to_location' do
    let(:from) { Engineering::Locations::Absolute.new(value_x: 10.0, value_y: 15.0, value_z: 3.0) }
    let(:to) { Engineering::Locations::Absolute.new(value_x: 5.0, value_y: 15.0, value_z: 9.0) }
    let(:relative_from_to) { described_class.from_location_to_location(from:, to:) }

    it 'returns an Engineering::Locations::Relative' do
      expect(relative_from_to).to be_an_instance_of(described_class)
    end

    it 'returns a relative location with correct components values' do
      expected_array = [[-5.0], [0.0], [6.0]]
      expect(relative_from_to.to_matrix.to_a).to match_array(expected_array)
    end

    it 'exposes right origin attribute' do
      expect(relative_from_to.origin.to_matrix.to_a).to match_array(origin.to_matrix.to_a)
    end
  end

  describe '#to_matrix' do
    it 'returns an Matrix object' do
      expect(relative.to_matrix).to be_an_instance_of(Matrix)
    end

    it 'returns right module' do
      expect(relative.to_matrix.to_a).to match_array([[value_1], [value_2], [value_3]])
    end
  end

  describe '#to_vector' do
    it 'returns an Engineering::Vector' do
      expect(relative.to_vector).to be_an_instance_of(Engineering::Vector)
    end

    it 'returns a vector with same components values as the relative location components' do
      expect(relative.to_vector.to_matrix.to_a).to match_array(relative.to_matrix.to_a)
    end
  end

  describe '#align_axis_1_with' do
    let(:another_relative) do
      described_class.new(
        value_1: -value_1,
        value_2: -value_2,
        value_3:,
        origin:
      )
    end
    let(:vector) { Engineering::Vector.based_on_location(location: relative) }

    before do
      relative.align_axis_1_with(vector:)
      another_relative.align_axis_1_with(vector:)
    end

    it 'updates angle' do
      expect(relative.angle).not_to be(0.0)
    end

    it "updates location's coordinates" do
      obtained = another_relative.to_matrix.to_a.map do |axis_value|
        [axis_value.first.round(1)]
      end
      expect(obtained).to match_array([[-5.0], [0.0], [6.0]])
    end
  end

  describe '#to_absolute' do
    let(:vector) { Engineering::Vector.based_on_location(location: relative) }
    let(:original_relative_values) { relative.to_matrix.to_a }

    before do
      relative.align_axis_1_with(vector:)
    end

    it "updates location's coordinates" do
      obtained = relative.to_matrix.to_a.map do |axis_value|
        [axis_value.first.round(1)]
      end
      expect(obtained).to match_array(original_relative_values.map { |axis_value| [axis_value.first.round(1)] })
    end

    it "returns absolute location's object" do
      expect(relative.to_absolute_location).to be_an_instance_of(Engineering::Locations::Absolute)
    end

    it "returns right absolute location's coordinates" do
      obtained = relative.to_absolute_location.to_matrix.to_a.map do |axis_value|
        [axis_value.first.round(1)]
      end
      expect(obtained).to match_array([[13.0], [19.0], [9.0]])
    end
  end
end
