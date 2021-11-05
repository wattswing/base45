# frozen_string_literal: true

#
# = base45.rb: methods for base45-encoding and -decoding strings
#

# The Base45 module provides for the encoding (#encode) and
# decoding (#decode) of binary data using a Base45 representation.

require_relative "base45/version"
require_relative "base45/encoding_table"

# Exposes two methods to decode and encode in base 45
module Base45
  class Error < StandardError; end

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
      return if payload.length < 2

      lookup = sliced_payload(payload)
      base45_vals = lookup.map { |c, d, e| c + d * 45 + (e ? e * 45**2 : 0) }

      base45_vals.pack("S>*").gsub(/\x00/, "")
    end

    private

    def encode_one_byte(byte)
      byte.divmod(45).reverse
    end

    def encode_two_bytes(first_byte, second_byte)
      x = (first_byte << 8) + second_byte
      e, x = x.divmod(45**2)
      d, c = x.divmod(45)

      [c, d, e]
    end

    def sliced_payload(payload)
      payload.chars.each_slice(3).map do |slice|
        slice.map { |char| INVERTED_BASE_45_TABLE[char]&.to_i }
      end
    end
  end
end
