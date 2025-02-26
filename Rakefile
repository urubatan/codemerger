require "rubygems"
require "bundler"
require "rake/testtask"
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn "Run `bundle install` to install missing gems"
  exit e.status_code
end

require "jeweler"
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "codemerger"
  gem.homepage = "https://github.com/urubatan/codemerger"
  gem.license = "MIT"
  gem.summary = %(Used to create blog posts and tecnical articles that need code samples, the code samples will be taken from the actual source code file instead of a copy paste approach)
  gem.description = %{This gem is used to help writing technical posts for wordpress.
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
  gem.email = "rodrigo@urubatan.com.br"
  gem.authors = [ "Rodrigo Urubatan" ]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

Rake::TestTask.new do |t|
  t.pattern = "test/*_spec.rb"
end
