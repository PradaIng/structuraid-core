require 'spec_helper'
require 'engineering/analysis/footing/centric_combined'
require 'elements/reinforcement/straight_longitudinal'
require 'materials/concrete'
require 'materials/steel'
require 'elements/reinforcement/rebar'
require 'loads/point_load'
require 'engineering/locations/relative'
require 'engineering/locations/absolute'
require 'errors/engineering/analysis/section_direction_error'
require 'elements/column/rectangular'
require 'elements/footing'
require 'byebug'

RSpec.describe Engineering::Analysis::Footing::CentricCombined do
  subject(:centric_combined_footing) do
    described_class.new(footing:, loads_from_columns:, section_direction:)
  end

  let(:load_from_column) { Loads::PointLoad.new(value: 1500, location: nil) }
  let(:section_direction) { :length_1 }
  let(:footing) do
    Elements::Footing.new(
      length_1:,
      length_2:,
      height:,
      material: Materials::Concrete.new(
        elastic_module: 1800,
        design_compression_strength: 28,
        specific_weight: 2.4
      ),
      cover_lateral:,
      cover_top:,
      cover_bottom:,
      longitudinal_bottom_reinforcement_length_1: nil,
      longitudinal_bottom_reinforcement_length_2: nil
    )
  end
  let(:length_1) { 8000 }
  let(:length_2) { 3000 }
  let(:height) { 250 }
  let(:cover_lateral) { 50 }
  let(:cover_top) { 50 }
  let(:cover_bottom) { 75 }
  let(:loads_from_columns) do
    [
      Loads::PointLoad.new(
        value: 40_000,
        location: Engineering::Locations::Absolute.new(
          value_x: 0,
          value_y: 4000,
          value_z: 0
        )
      ),
      Loads::PointLoad.new(
        value: 10_000,
        location: Engineering::Locations::Absolute.new(
          value_x: 0,
          value_y: -1000,
          value_z: 0
        )
      )
    ]
  end

  describe '#solicitation_load' do
    let(:expected_solicitation) { loads_from_columns.sum(&:value) / length_1 }

    it 'returns the right solicitation on the food' do
      expect(centric_combined_footing.solicitation_load).to be(expected_solicitation)
    end
  end

  describe 'private methods' do
    describe '#absolute_centroid' do
      let(:expected_centroid) do
        Engineering::Locations::Absolute.new(
          value_x: 0,
          value_y: 3000,
          value_z: 0
        )
      end

      it 'returns the right absolute centroid' do
        expect(centric_combined_footing.send(:absolute_centroid).to_a).to match_array(expected_centroid.to_a)
      end
    end

    describe '#sort_point_loads_relative_to_centroid' do
      it 'returns sorted columns loads' do
        expected_sorted_loads = [
          loads_from_columns[1],
          loads_from_columns[0]
        ]
        expect(centric_combined_footing.send(:sort_point_loads_relative_to_centroid)).to eq(expected_sorted_loads)
      end
    end

    describe '#vector_left_load_to_footing_edge' do
      it 'returns a vector' do
        expect(centric_combined_footing.send(:vector_left_load_to_footing_edge)).to be_a(Engineering::Vector)
      end

      it 'returns a vector with magnitude of 05 * section_length' do
        vecotr_to_edge = centric_combined_footing.send(:vector_left_load_to_footing_edge)
        expect(vecotr_to_edge.magnitude).to be(length_1 * 0.5)
      end

      it 'returns a vector with right components' do
        expected_direction = [0.0, -1.0, 0.0]
        vecotr_to_edge = centric_combined_footing.send(:vector_left_load_to_footing_edge)
        expect(vecotr_to_edge.direction).to match_array(expected_direction)
      end
    end

    describe '#vector_right_load_to_footing_edge' do
      it 'returns a vector' do
        expect(centric_combined_footing.send(:vector_right_load_to_footing_edge)).to be_a(Engineering::Vector)
      end

      it 'returns a vector with magnitude of 05 * section_length' do
        vecotr_to_edge = centric_combined_footing.send(:vector_right_load_to_footing_edge)
        expect(vecotr_to_edge.magnitude).to be(length_1 * 0.5)
      end

      it 'returns a vector with right components' do
        expected_direction = [0.0, 1.0, 0.0]
        vecotr_to_edge = centric_combined_footing.send(:vector_right_load_to_footing_edge)
        expect(vecotr_to_edge.direction).to match_array(expected_direction)
      end
    end
  end
end
