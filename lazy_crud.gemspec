# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "lazy_crud/version"

Gem::Specification.new do |s|
  s.name        = "lazy_crud"
  s.version     = LazyCrud::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license     = "MIT"
  s.authors     = ["L. Preston Sego III"]
  s.email       = "LPSego3+dev@gmail.com"
  s.homepage    = "https://github.com/NullVoxPopuli/lazy_crud"
  s.summary     = "LazyCrud-#{LazyCrud::VERSION}"
  s.description = "Lazy way to implement common actions in controllers in Rails."


  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 2.0'

  s.add_runtime_dependency "activesupport"
  s.add_runtime_dependency "i18n"

  # for testing a gem with a rails app (controller specs)
  # https://codingdaily.wordpress.com/2011/01/14/test-a-gem-with-the-rails-3-stack/
  s.add_development_dependency "bundler"
  s.add_development_dependency "rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "paranoia"
  s.add_development_dependency "awesome_print"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry-byebug"
  s.add_development_dependency "codeclimate-test-reporter"

end
