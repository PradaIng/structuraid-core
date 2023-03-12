module DesignCodes
  class UnrecognizedValueError < StandardError
    def initialize(name, value)
      super("#{value} for #{name} param couldnt be recognized")
    end
  end
end
