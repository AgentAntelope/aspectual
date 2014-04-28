# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aspectual/version'

Gem::Specification.new do |spec|
  spec.name          = "aspectual"
  spec.version       = Aspectual::VERSION
  spec.authors       = ["Alex Sunderland"]
  spec.email         = ["agentantelope+aspectual@gmail.com"]
  spec.description   = %q{
    A simple gem to support minimal Aspect Oriented Programming in ruby.
  }
  spec.summary       = %q{A gem to help with AOP.}
  spec.homepage      = "https://github.com/AgentAntelope/aspectual"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
