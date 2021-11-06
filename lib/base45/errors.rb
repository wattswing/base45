# frozen_string_literal: true

module Base45
  class IllegalCharacterError < StandardError; end

  class ForbiddenLengthError < StandardError; end
end
