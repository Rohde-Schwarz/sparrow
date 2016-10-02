# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
rails_version = ENV["RAILS_VERSION"] || "4.2"
ruby_version = File.open(File.join(__dir__, '.ruby-version')).read.chomp
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sparrow/version'

Gem::Specification.new do |spec|
  spec.name        = "cp-sparrow"
  spec.version     = Sparrow::VERSION
  spec.authors     = ["Daniel Schmidt", "Andreas Müller"]
  spec.email       = ["dsci@code79.net", "anmuel86@gmail.com"]
  spec.homepage    = "https://github.com/gateprotectGmbH/sparrow"
  spec.summary     = %q{A POC to have a Rack middleware parsing the params keys into underscore}
  spec.description = %q{
    A collection of 2 middlewares to convert json formats to other formats
such as camelCase and snake_case. Both converting responses and requests are
supported.
  }
  spec.homepage    = "https://github.com/GateprotectGmbH/sparrow"
  spec.license     = "MIT"
  spec.required_ruby_version = ">= #{ruby_version}"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", '~> 3'
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rails", rails_version
end
