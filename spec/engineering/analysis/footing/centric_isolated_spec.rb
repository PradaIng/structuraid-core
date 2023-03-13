require 'spec_helper'
require 'engineering/analysis/footing/centric_isolated'
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

RSpec.describe Engineering::Analysis::Footing::CentricIsolated do
  subject(:centric_isolated_footing) do
    described_class.new(footing:, load_from_column:, section_direction:)
  end

  let(:origin) { Engineering::Locations::Absolute.new(value_x: 0, value_y: 0, value_z: 0) }

  let(:load_from_column) { Loads::PointLoad.new(value: 1500, location: nil) }
  let(:effective_height) { 250 }
  let(:section_direction) { :length_1 }
  let(:orthogonal_direction) { :length_2 }

  let(:footing) do
    Elements::Footing.new(
      length_1:,
      length_2:,
      height:,
      material: Materials::Concrete.new(elastic_module: 1800, design_compression_strength: 28, specific_weight: 2.4),
      cover_lateral:,
      cover_top:,
      cover_bottom:,
      longitudinal_bottom_reinforcement_length_1:,
      longitudinal_bottom_reinforcement_length_2:
    )
  end
  let(:length_1) { 1500 }
  let(:length_2) { 1500 }
  let(:height) { 500 }
  let(:cover_lateral) { 50 }
  let(:cover_top) { 50 }
  let(:cover_bottom) { 75 }
  let(:longitudinal_bottom_reinforcement_length_1) do
    Elements::Reinforcement::StraightLongitudinal.new(
      distribution_direction: :length_1
    )
  end
  let(:longitudinal_bottom_reinforcement_length_2) do
    Elements::Reinforcement::StraightLongitudinal.new(
      distribution_direction: :length_2
    )
  end
  let(:rebar_material) { Materials::Steel.new(yield_stress: 4200) }
  let(:rebar_n3) do
    Elements::Reinforcement::Rebar.new(
      number: 3,
      material: rebar_material
    )
  end
  let(:start_location_1) do
    Engineering::Locations::Relative.new(
      value_1: -0.5 * length_1 + cover_lateral,
      value_2: -0.5 * length_2 + cover_lateral,
      value_3: cover_bottom,
      origin:
    )
  end
  let(:end_location_1) do
    Engineering::Locations::Relative.new(
      value_1: 0.5 * length_1 - cover_lateral,
      value_2: 0.5 * length_2 - cover_lateral,
      value_3: cover_bottom,
      origin:
    )
  end
  let(:start_location_2) do
    Engineering::Locations::Relative.new(
      value_1: -0.5 * length_1 + cover_lateral,
      value_2: -0.5 * length_2 + cover_lateral,
      value_3: cover_bottom,
      origin:
    )
  end
  let(:end_location_2) do
    Engineering::Locations::Relative.new(
      value_1: 0.5 * length_1 - cover_lateral,
      value_2: 0.5 * length_2 - cover_lateral,
      value_3: cover_bottom,
      origin:
    )
  end

  before do
    footing.longitudinal_bottom_reinforcement_length_1.add_layer(
      start_location: start_location_1,
      end_location: end_location_1,
      amount_of_rebars: 2,
      rebar: rebar_n3
    )
    footing.longitudinal_bottom_reinforcement_length_2.add_layer(
      start_location: start_location_2,
      end_location: end_location_2,
      amount_of_rebars: 2,
      rebar: rebar_n3
    )
    footing.longitudinal_bottom_reinforcement_length_2.layers.map do |layer|
      layer.reposition(above_middle: false, offset: rebar_n3.diameter)
    end
  end

  describe '#solicitation_load' do
    it 'returns the solicitation load for the cut direction' do
      expectet_total_load = load_from_column.value * footing.public_send(orthogonal_direction)
      expect(centric_isolated_footing.solicitation_load).to eq(expectet_total_load / footing.horizontal_area)
    end
  end

  describe '#max_shear_solicitation' do
    it 'returns the max shear solicitation' do
      expect(centric_isolated_footing.max_shear_solicitation).to eq(load_from_column.value)
    end
  end

  describe '#shear_solicitation_at' do
    it 'returns the shear, is less than the max_shear_solicitation' do
      expect(
        centric_isolated_footing.shear_solicitation_at(
          distance_from_footing_center: 30
        ) < centric_isolated_footing.max_shear_solicitation
      ).to be(true)
    end
  end

  describe '#bending_solicitation' do
    it 'returns the rigth bending moment' do
      max_shear_solicitation = centric_isolated_footing.max_shear_solicitation
      expected_bending_solicitation = 0.25 * max_shear_solicitation * footing.public_send(section_direction)
      expect(centric_isolated_footing.bending_solicitation).to be(expected_bending_solicitation)
    end
  end
end
