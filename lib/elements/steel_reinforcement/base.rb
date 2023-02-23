module Elements
  module SteelReinforcement
    class Base
      attr_reader :diameter, :number, :material

      def initialize(number:, material:, standard_rebars:)
        @number = number
        @material = material

        rebar_data = standard_rebars.find_standard_rebar(number:)
        @diameter = rebar_data['diameter'].to_f
      end
    end
  end
end