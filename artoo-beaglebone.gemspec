# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "artoo-beaglebone/version"

Gem::Specification.new do |s|
  s.name        = "artoo-beaglebone"
  s.version     = Artoo::Beaglebone::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Adrian Zankich"]
  s.email       = ["artoo@hybridgroup.com"]
  s.homepage    = "http://artoo.io"
  s.summary     = %q{Artoo adaptor and driver for Beaglebone}
  s.description = %q{Artoo adaptor and driver for Beaglebone}

  s.rubyforge_project = "artoo-beaglebone"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'artoo', '~> 1.2.1'
  # TODO: add your development dependencies here
  # EXAMPLE:
  # s.add_development_dependency 'minitest', '~> 5.0'
  # s.add_development_dependency 'minitest-happy'
  # s.add_development_dependency 'mocha', '~> 0.14.0'
end
