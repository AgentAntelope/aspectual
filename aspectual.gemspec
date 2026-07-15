lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aspectual/version'

Gem::Specification.new do |spec|
  spec.name          = 'aspectual'
  spec.version       = Aspectual::VERSION
  spec.authors       = ['Fell Sunderland']
  spec.email         = ['agentantelope+aspectual@gmail.com']
  spec.description   = '
    A simple gem to support minimal Aspect Oriented Programming in ruby.
  '
  spec.summary       = 'A gem to help with AOP.'
  spec.homepage      = 'https://github.com/AgentAntelope/aspectual'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/).reject { |f| f.end_with?('gem') }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.1'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
end
