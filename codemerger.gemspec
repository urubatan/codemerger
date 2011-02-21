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
  s.description = %q{This gem is used to help writing technical posts for wordpress.
  The output is copied and pasted to a post into my wordpress blog, and the code gets colored using the plugin wp-syntax, and the output can be turned into PDF with the plugin wp-mpdf.

Today this gem supports source files in the following languages:

* Ruby (including Rakefile and Gemfile)
* Java
* YAML
* HTML
* XML
* Scala
* CSS
* Javascript
* Bash
* Batch

All other files are configured as "text".}

  s.rubyforge_project = "codemerger"
  s.add_dependency 'maruku'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
