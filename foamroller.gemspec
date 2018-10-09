$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "foamroller/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "foamroller"
  s.version     = Foamroller::VERSION
  s.authors     = ["christopher nguyen"]
  s.email       = ["christoph.nguyen@gmail.com"]
  s.homepage    = "https://github.com/lestopher/foamroller"
  s.summary     = "Mountable ui for rollout"
  s.description = "Mountable ui for rollout"
  s.license     = "MIT"

  s.files = Dir["{lib}/**/*", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.executables = ['foamroller']
  s.default_executable = 'foamroller'

  s.add_runtime_dependency "sinatra", "~> 2"
  s.add_runtime_dependency "rollout", "~> 2.4"
  s.add_runtime_dependency "redis", "~> 4.0"

  s.add_development_dependency "thin", "~> 1.7"
  s.add_development_dependency "bundler", "~> 1.12"
  s.add_development_dependency "rspec", "~> 3.5"
  s.add_development_dependency "rake", "~> 11.3"
  s.add_development_dependency "rack-test", "~> 0.6"
  s.add_development_dependency "mock_redis", "~> 0.17"
  s.add_development_dependency "pry", "~> 0.10"

end
