# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'YouAreDaChef/version'

Gem::Specification.new do |spec|
  spec.name          = "YouAreDaChef"
  spec.version       = YouAreDaChef::VERSION
  spec.authors       = ["Robert Krzysztoforski"]
  spec.email         = ["robert.krzysztoforski@gmail.com"]

  spec.summary       = %q{Support AOP methods to Ruby classes.}
  spec.description   = %q{Support AOP methods to Ruby classes.}
  spec.homepage      = 'https://github.com/brissenden/YouAreDaChef'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', "~> 3.2"
end
