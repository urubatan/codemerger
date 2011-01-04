# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "codemerger/version"

Gem::Specification.new do |s|
  s.name        = "codemerger"
  s.version     = Codemerger::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Rodrigo Urubatan"]
  s.email       = ["rodrigo@urubatan.com.br"]
  s.homepage    = "http://www.urubatan.com.br"
  s.summary     = %q{Used to create blog posts and tecnical articles that need code samples, the code samples will be taken from the actual source code file instead of a copy paste approach}
  s.description = %q{Used to create blog posts and tecnical articles that need code samples, the code samples will be taken from the actual source code file instead of a copy paste approach}

  s.rubyforge_project = "codemerger"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
