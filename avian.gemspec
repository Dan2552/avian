
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "avian/version"

Gem::Specification.new do |spec|
  spec.name          = "avian"
  spec.version       = Avian::VERSION
  spec.authors       = ["Daniel Inkpen"]
  spec.email         = ["dan2552@gmail.com"]

  spec.summary       = "2D Ruby game development framework."
  spec.description   = "Avian is a 2D Ruby game engine and development framework that abstracts away underlying platform-specific intricacies. Like some other well-known frameworks, Avian encourages beautiful code by favoring convention over configuration."
  spec.homepage      = "https://github.com/Dan2552/avian"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "pry", "~> 0.12"
  spec.add_development_dependency "rspec", "~> 3.8"

  spec.add_dependency "thor", "~> 0.20.3"
  spec.add_dependency "activesupport", "~> 5.2"
  spec.add_dependency "process_output_wrapper", "> 0"
end
