require "simplecov"
require 'minitest/simplecov_plugin'
SimpleCov.start do
  add_filter "/test/"
  #track_files "lib/**/*.rb"
end
require "minitest/autorun"
