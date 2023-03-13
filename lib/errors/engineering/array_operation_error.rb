module Engineering
  class ArrayOperationError < StandardError
    BASIC_MESSAGES = {
      array_of_arrays: 'the array must be an array of arrays, each element is a row of the multi dimension array',
      self_size: 'the array must contain the same size at each row',
      other_size: "array 'b' must have same amount of rows as array a has amount of columns",
      columns_rows: "columns of 'a' array must be the same amount of rows of 'b'",
      diferent_size: 'arrays must be of the same size'
    }.freeze

    def initializes(message: nil, operation_key: nil)
      @operation_key = operation_key
      @message = message
      @message = BASIC_MESSAGES[operation_key] unless message

      super("Operation no valid: #{@message}")
    end
  end
end
