module Engineering
  module Analysis
    class SectionDirectionError < StandardError
      def initialize(section_direction, valid_options)
        message = "#{section_direction} is not a valid direction, should one of #{valid_options}"

        super(message)
      end
    end
  end
end
