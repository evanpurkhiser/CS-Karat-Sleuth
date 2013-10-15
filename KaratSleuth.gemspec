# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'KaratSleuth/version'

Gem::Specification.new do |spec|
  spec.name          = "KaratSleuth"
  spec.version       = KaratSleuth::VERSION
  spec.authors       = ["Evan Purkhiser", "Heather Michaud", "Timmothy Mott"]
  spec.email         = ["evanpurkhiser@gmail.com", "hmm34@zips.uakron.edu", "mayaswrath@gmail.com"]
  spec.description   = "A simplistic spam heuristics tool for our AI course - Fall 2013"
  spec.summary       = "A gem that learns from a training set of email data and can then detect spam"
  spec.homepage      = "https://github.com/EvanPurkhiser/CS-Karat-Sleuth"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
