require 'minitest/autorun'
require 'codemerger/version'

describe Codemerger do
  it "should return the correct version number" do
    "0.3.2".must_equal Codemerger::VERSION
  end
end
