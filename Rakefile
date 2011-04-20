require 'simplecov'
require 'bundler'
require 'rake/testtask'
SimpleCov.start
require 'codemerger'
Bundler::GemHelper.install_tasks :name => 'codemerger'
Rake::TestTask.new do |t|
  t.pattern = "test/*_spec.rb"
end