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
      return if payload.length.zero?

      return encode_for_single_char(payload) if payload.bytesize < 2

      encode_for_multipe_chars(payload)
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

    def sliced_payload(payload)
      payload.chars.each_slice(3).map do |slice|
        slice.map { |char| INVERTED_BASE_45_TABLE[char]&.to_i }
      end
    end

    def encode_for_single_char(payload)
      keys = payload.bytes[0].divmod(45).reverse

      keys.map { |i| BASE_45_TABLE[i.to_s.rjust(2, "0")] }.join
    end

    def encode_for_multipe_chars(payload)
      # 16-bit unsigned (unsigned char) - except big endian
      bytes16 = payload.unpack("S>*")

      is_odd = payload.bytesize.odd? && payload.bytes[-1] < 256
      bytes16 << payload.bytes[-1] if is_odd

      modulo45_bytes = modulo45_array(bytes16)

      modulo45_bytes.flatten.map do |i|
        BASE_45_TABLE[i.to_s.rjust(2, "0")]
      end.join
    end

    def modulo45_array(bytes16)
      bytes16.map do |byte|
        arr = []
        multiplier, rest = byte.divmod(45**2)
        arr << multiplier if multiplier.positive?
        arr.push(*rest.divmod(45))

        arr.reverse
      end
    end
  end
end
