require 'spec_helper'
require 'engineering/analysis/footing/centric_isolated'
require 'elements/r_c/column/rectangular'
require 'elements/footing'
require 'loads/point_load'

RSpec.describe Engineering::Analysis::Footing::CentricIsolated do
  subject(:centric_isolated_footing) do
    described_class.new(column:, footing:, effective_height:, load_from_column:, cut_direction:)
  end

  let(:column) do
    Elements::RC::Column::Rectangular.new(length_x: 500, length_y: 300, height: 2900, material: 'concrete')
  end
  let(:footing) do
    Elements::Footing.new(length_x: 4000, length_y: 4000, height: 400, material: 'concrete')
  end
  let(:load_from_column) { Loads::PointLoad.new(value: 1500, location: nil) }
  let(:effective_height) { 250 }
  let(:cut_direction) { :length_x }
  let(:ortogonal_direction) { :length_y }

  describe '#solicitation_load' do
    it 'returns the solicitation load for the cut direction' do
      expected_solicitation = load_from_column.value * footing.send(ortogonal_direction) / footing.horizontal_area
      expect(centric_isolated_footing.solicitation_load).to eq(expected_solicitation)
    end
  end

  describe '#max_shear_solicitation' do
    it 'returns the max shear solicitation' do
      expect(centric_isolated_footing.max_shear_solicitation).to eq(load_from_column.value)
    end
  end

  describe '#shear_solicitation' do
    it 'returns the shear solicitation, is less than the max_shear_solicitation' do
      expect(centric_isolated_footing.shear_solicitation < centric_isolated_footing.max_shear_solicitation).to be(true)
    end
  end

  describe '#bending_solicitation' do
    it 'returns the rigth bending moment' do
      expected_bending_solicitation = 0.25 * centric_isolated_footing.max_shear_solicitation * footing.send(cut_direction)
      expect(centric_isolated_footing.bending_solicitation).to be(expected_bending_solicitation)
    end
  end

  # describe 'when create an instance with a worong cut_direction' do
  #   let(:wrong_cut_direction) { :length_z }

  #   it 'returns an error' do
  #     expect(described_class.new(column:,
  #                                footing:,
  #                                effective_height:,
  #                                load_from_column:,
  #                                cut_direction: wrong_cut_direction)).to raise_error(ArgumentError)
  #   end
  # end
end