# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pa_ruby_tools/version'

Gem::Specification.new do |spec|
  spec.name          = "pa_ruby_tools"
  spec.version       = PaRubyTools::VERSION
  spec.authors       = ["leffen"]
  spec.email         = ["leffen@gmail.com"]
  spec.description   = %q{Ruby dev helper tools for ProgramArkitekten}
  spec.summary       = %q{Collection of small tools and utilities for doing ruby development}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.bindir      = 'bin'

  spec.add_dependency 'gem-release'
  spec.add_dependency 'slop'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
