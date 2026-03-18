require_relative 'lib/easy_peasy_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'easy-peasy-api'
  spec.version       = EasyPeasyApi::VERSION
  spec.authors       = ['Nathan']
  spec.summary       = 'Filesystem-based API routing for Rails'
  spec.description   = 'A Rails Railtie that dynamically routes API requests to controllers based on the filesystem structure.'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.0'

  spec.files         = Dir['lib/**/*', 'LICENSE', 'README.md']
  spec.require_paths = ['lib']

  spec.add_dependency 'actionpack', '>= 7.0'
  spec.add_dependency 'railties', '>= 7.0'

  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rack-test', '~> 2.0'
  spec.add_development_dependency 'rails', '>= 7.0'
end
