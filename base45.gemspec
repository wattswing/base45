# frozen_string_literal: true

require_relative "lib/base45/version"

Gem::Specification.new do |spec|
  spec.name          = "base45"
  spec.version       = Base45::VERSION
  spec.authors       = ["Wattswing"]
  spec.email         = ["wattswing@gmail.com"]

  spec.summary       = "Decode / encode in base 45"
  spec.description   = spec.summary

  spec.homepage      = "https://github.com/wattswing/base45"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.0.2"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_development_dependency "rspec", "~> 3.2"
end
