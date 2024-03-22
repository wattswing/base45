# frozen_string_literal: true

module Base45
  BASE_45_TABLE = [
    *('0'..'9').to_a,
    *('A'..'Z').to_a,
    ' ', '$', '%', '*', '+', '-', '.', '/', ':'
  ].each_with_object({}).with_index { |(index, memo), i| memo[i] = index }

  INVERTED_BASE_45_TABLE = BASE_45_TABLE.invert.freeze
end
