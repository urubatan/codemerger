require_relative "test_helper"
require "codemerger"
describe Codemerger::Merger do
  def setup
    @merger = Codemerger::Merger.new "test"
  end
  it "should return the correct language string" do
    _(@merger.get_language_str(".yml")).must_equal "yaml"
    _(@merger.get_language_str(".xml")).must_equal "xml"
    _(@merger.get_language_str(".html")).must_equal "xml"
    _(@merger.get_language_str(".rb")).must_equal "ruby"
    _(@merger.get_language_str(".java")).must_equal "java"
    _(@merger.get_language_str(".scala")).must_equal "scala"
    _(@merger.get_language_str(".erb")).must_equal "erb"
    _(@merger.get_language_str(".xsl")).must_equal "xslt"
    _(@merger.get_language_str(".css")).must_equal "css"
    _(@merger.get_language_str(".js")).must_equal "javascript"
    _(@merger.get_language_str(".sh")).must_equal "bash"
    _(@merger.get_language_str(".bat")).must_equal "batch"
    _(@merger.get_language_str(".xhtml")).must_equal "xml"
    _(@merger.get_language_str(nil)).must_equal "ruby"
    _(@merger.get_language_str("niaaa")).must_equal "text"
    _(@merger.get_language_str(".coffee")).must_equal "coffeescript"
    _(@merger.get_language_str(".scss")).must_equal "scss"
  end
  it "should delete and re-create the output directory" do
    FileUtils.mkdir_p "output"
    out_f = File.new("output/temp.txt", "w")
    out_f << "content"
    out_f.close
    @merger.clean_dirs
    _(File.exist?("output/temp.txt")).must_equal false
  end
  it "should return the correctly formated output for an embedded file" do
    expected = "\n      <b>test/sample.rb</b>\n      <pre line=\"1\" lang=\"ruby\">\n      def sample\n  println \"sample\"\nend\n\n      </pre>\n      "
    actual = @merger.build_html_merged_file_content("test/sample.rb")
    _(expected).must_equal actual
  end
  it "should process HTML and Markdown files" do
    @merger.process_files(html: true)
    _(File.exist?("output/test/test.html")).must_equal true
    _(File.exist?("output/test/test2.html")).must_equal true
  end
  it "should process only Markdown files" do
    @merger.clean_dirs
    @merger.process_files
    _(File.exist?("output/test/test2.html")).must_equal true
  end
end
