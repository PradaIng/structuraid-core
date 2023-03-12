require 'spec_helper'
require 'design_codes/schemas/rc/footings/punching_shear_capacity_schema'
require 'errors/design_codes/missing_param_error'

RSpec.describe DesignCodes::Schemas::RC::Footings::PunchingShearCapacitySchema do
  describe '.validate!' do
    subject(:result) { described_class.validate!(params) }

    let(:params) do
      {
        column_section_width: 300,
        column_section_height: 500,
        design_compression_strength: 28,
        critical_section_perimeter: 3200,
        effective_height: 240,
        light_concrete_modification_factor: 1,
        column_location: :interior
      }
    end

    it 'returns true' do
      expect(result).to eq(true)
    end

    describe 'when required param is missing' do
      let(:params) { {} }

      it 'raises an error' do
        expect { result }.to raise_error(DesignCodes::MissingParamError)
      end
    end
  end

  describe '.structurize' do
    subject(:result) { described_class.structurize(params) }

    let(:params) do
      {
        column_section_width: 300,
        column_section_height: 500,
        design_compression_strength: 28,
        critical_section_perimeter: 3200,
        effective_height: 240,
        light_concrete_modification_factor: 1,
        column_location: :interior
      }
    end

    # rubocop:disable RSpec/ExampleLength
    it 'returns a struct with the required param' do
      expect(result.members).to match_array(
        %i[
          column_section_width
          column_section_height
          design_compression_strength
          critical_section_perimeter
          effective_height
          light_concrete_modification_factor
          column_location
          schema
        ]
      )
    end
    # rubocop:enable RSpec/ExampleLength
  end
end
