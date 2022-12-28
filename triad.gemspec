lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "triad/version"

Gem::Specification.new do |spec|
  spec.name = "triad"
  spec.version = Triad::VERSION
  spec.authors = ["'Jim Gay'"]
  spec.email = ["jim@saturnflyer.com"]
  spec.description = "Triad allows you to access data from keys, descriptors, and values"
  spec.summary = "Manage a collection with 3 data points"
  spec.homepage = "https://github.com/saturnflyer/triad"
  spec.license = "MIT"

  spec.files = Dir["lib/**/*"] + %w[Gemfile LICENSE.txt README.md Rakefile triad.gemspec test/triad_test.rb]
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "concurrent-ruby", "> 0.9"
end
