require_relative 'test_helper'
require "codemerger/version"

describe Codemerger do
  it "should return the correct version number" do
    _("0.5.0").must_equal Codemerger::VERSION
  end
end
