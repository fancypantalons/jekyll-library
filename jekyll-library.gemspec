# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jekyll-library/version"

Gem::Specification.new do |spec|
  spec.name          = "jekyll-library"
  spec.version       = Jekyll::Library::VERSION
  spec.authors       = ["Brett Kosinski"]
  spec.email         = ["brettk@b-ark.ca"]
  spec.summary       = "A Jekyll plugin to support automatically pulling down book information and covers for inclusion in posts."
  spec.homepage      = "http://github.com/fancypantalons/jekyll-library"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.test_files    = spec.files.grep(%r!^spec/!)
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.3.0"

  spec.add_runtime_dependency "jekyll", ">= 3.7", "< 5.0"
  spec.add_runtime_dependency "nokogiri", "~> 1.6"

  spec.add_development_dependency "bundler"
end
