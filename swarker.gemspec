# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'swarker/version'

Gem::Specification.new do |spec|
  spec.name          = 'swarker'
  spec.version       = Swarker::VERSION
  spec.authors       = ['Sergey Ponomarev']
  spec.email         = ['me@sergey-ponomarev.ru']

  spec.summary       = 'Converts lurker schemas to swagger schema'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|public|lurker)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 4.2'
  spec.add_dependency 'thor'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-collection_matchers'
  spec.add_development_dependency 'rubocop'
end
