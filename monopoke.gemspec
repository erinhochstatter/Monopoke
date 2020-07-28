lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "monopoke/version"

Gem::Specification.new do |spec|
  spec.name          = "monopoke"
  spec.version       = Monopoke::VERSION
  spec.authors       = ["Erin Hochstatter"]
  spec.email         = ["ehochstatter@gmail.com"]

  spec.summary       = "A totally unique turn-based game involving monsters that fit in your pocket"


  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 6.0.2.1"
  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "pry", "~> 0.13.1"
  spec.add_development_dependency "pry-byebug", "~> 3.9.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.88.0"
  spec.add_runtime_dependency "thor", "~> 1.0.1"
end
