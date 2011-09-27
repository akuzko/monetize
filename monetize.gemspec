# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "monetize/version"

Gem::Specification.new do |s|
  s.name        = "monetize"
  s.version     = Monetize::VERSION
  s.authors     = ["Artem Kuzko"]
  s.email       = ["AKuzko@sphereconsultinginc.com"]
  s.homepage    = ""
  s.summary     = %q{monetize gem for money representation and operations}
  s.description = %q{
    This gem introduces Money class for a convinient way of dealing with money calculations.
    It also provides CalculationHelper module for a more convinient calculations upon
    money objects. However, currently it is not thread safe.
  }

  #s.rubyforge_project = "monetize"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
