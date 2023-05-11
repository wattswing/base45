# frozen_string_literal: true

ENCODING_EXAMPLES = {
  "AB" => "BB8",
  "Hello!!" => "%69 VD92EX0",
  "base-45" => "UJCLQE7W581",
  "123456789" => "*96DL6WW66:6C1",
  "0" => "31",
  "1" => "41",
  "6" => "91",
  "7" => "A1",
  "8" => "B1",
  "9" => "C1",
  "0123" => "746QF6",
  "0987654321" => "F46 47H%6/Q6OF6",
  "45" => "0R6",
  "0123456789" => "746QF60R6J%6%47",
  "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890" => "BB8UM84Y8N09.B9GN9ZY991ASCA2OALZA+1BEDB*96DL6WW66:6FA7",
  "blablabla5445" => "-JC0ECPVD-JC0DC:Q681",
  '!@#$%^&*()' => "794-J4QW45$4L35",
  "ietf!" => "QED8WEX0",
  "ietf" => "QED8WE",
  "" => ""
}.freeze

RSpec.describe(Base45) do
  context("Encoding") do
    ENCODING_EXAMPLES.each do |decoded, encoded|
      it "in base 45 #{decoded.inspect} to #{encoded.inspect} properly" do
        expect(Base45.encode(decoded)).to eq(encoded)
      end
    end
  end

  context("Decoding") do
    ENCODING_EXAMPLES.each do |decoded, encoded|
      it "from base 45 #{encoded.inspect} to #{decoded.inspect} properly" do
        expect(Base45.decode(encoded)).to eq(decoded)
      end
    end
  end

  context("Handling errors") do
    it "raises IllegalCharacterError when decoding using unknown characters" do
      expect { Base45.decode("^{}[]!&") }.to \
        raise_error Base45::IllegalCharacterError
    end

    it "raises ForbiddenLengthError when decoding an even sequence" do
      expect { Base45.decode("ABCD") }.to \
        raise_error Base45::ForbiddenLengthError
    end

    it "raises OverflowError when decoding unbounded sequence" do
      expect { Base45.decode "///" }.to \
        raise_error Base45::OverflowError
    end
  end

  it "has a version number" do
    expect(Base45::VERSION).not_to be(nil)
  end
end
