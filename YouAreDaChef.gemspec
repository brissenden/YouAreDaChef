lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'YouAreDaChef/version'

Gem::Specification.new do |spec|
  spec.name          = 'YouAreDaChef'
  spec.version       = YouAreDaChef::VERSION
  spec.authors       = ['Robert Krzysztoforski']
  spec.email         = ['robert.krzysztoforski@gmail.com']

  spec.summary       = 'Simple AOP library for Ruby.'
  spec.description   = 'Simple AOP library for Ruby.'
  spec.homepage      = 'https://github.com/brissenden/YouAreDaChef'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'mutant-rspec', '~> 0.7.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
end
