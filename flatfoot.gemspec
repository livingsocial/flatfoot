# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flatfoot/version'

Gem::Specification.new do |spec|
  spec.name          = "flatfoot"
  spec.version       = Flatfoot::VERSION
  spec.authors       = ["Dan Mayer"]
  spec.email         = ["dan.mayer@livingsocial.com"]
  spec.description   = %q{Discover dead view files in your app. Track view layer render usage}
  spec.summary       = %q{Discover dead view files in your app. Track view layer render usage}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "mocha", "~> 0.14.0"
  spec.add_development_dependency "shoulda"
  spec.add_development_dependency "test-unit"
  spec.add_development_dependency "rack"
  spec.add_development_dependency "simplecov"
end
