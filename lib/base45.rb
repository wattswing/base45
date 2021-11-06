# frozen_string_literal: true

#
# = base45.rb: methods for base45-encoding and -decoding strings
#

# The Base45 module provides for the encoding (#encode) and
# decoding (#decode) of binary data using a Base45 representation.

require_relative "base45/version"
require_relative "base45/encoding_table"
require_relative "base45/errors"

# Exposes two methods to decode and encode in base 45
module Base45
  class << self
    # Returns the Base45-encoded version of +payload+
    #
    #    require 'base45'
    #    Base45.encode("Encoding in base 45 !")
    #
    # <i>Generates:</i>
    #
    #    :Y8UPCAVC3/DH44M-DUJCLQE934AW6X0
    def encode(payload)
      sliced_bytes = payload.each_byte.each_slice(2)
      base45_bytes = sliced_bytes.flat_map do |byte_a, byte_b|
        byte_b ? encode_two_bytes(byte_a, byte_b) : encode_one_byte(byte_a)
      end

      base45_bytes.map do |byte45|
        BASE_45_TABLE[byte45.to_s.rjust(2, "0")]
      end.join
    end

    # Returns the Base45-decoded version of +payload+
    #
    #    require 'base45'
    #    Base45.encode(":Y8UPCAVC3/DH44M-DUJCLQE934AW6X0")
    #
    # <i>Generates:</i>
    #
    #    Encoding in base 45 !
    def decode(payload)
      map45_chars(payload).each_slice(3).flat_map do |c, d, e|
        c && d or raise ForbiddenLengthError
        v = c + d * 45
        bytes_from_base45(e, v)
      end.pack("C*")
    end

    private

    def bytes_from_base45(last_triplet_byte, factor45)
      return [factor45] unless last_triplet_byte

      factor45 += last_triplet_byte * (45**2)
      x, y = factor45.divmod(256)

      [x, y]
    end

    def encode_one_byte(byte)
      byte.divmod(45).reverse
    end

    def encode_two_bytes(first_byte, second_byte)
      x = (first_byte << 8) + second_byte
      e, x = x.divmod(45**2)
      d, c = x.divmod(45)

      [c, d, e]
    end

    def map45_chars(string)
      string.upcase.each_char.map do |c|
        char_byte = INVERTED_BASE_45_TABLE[c]
        raise(IllegalCharacterError, c.inspect) unless char_byte

        char_byte.to_i
      end
    end
  end
end
