require 'minitest/autorun'
require 'codemerger'

describe Codemerger::Merger do
  def setup
    @merger = Codemerger::Merger.new 'test'
  end
  it "should return the correct language string" do 
        @merger.get_language_str(".yml").must_equal "lang=\"yaml\""
        @merger.get_language_str(".xml").must_equal "lang=\"xml\""
        @merger.get_language_str(".html").must_equal "lang=\"xml\""
        @merger.get_language_str(".rb").must_equal "lang=\"ruby\""
        @merger.get_language_str(".java").must_equal "lang=\"java\""
        @merger.get_language_str(".scala").must_equal "lang=\"scala\""
        @merger.get_language_str(".erb").must_equal "lang=\"ruby\""
        @merger.get_language_str(".xsl").must_equal "lang=\"xml\""
        @merger.get_language_str(".css").must_equal "lang=\"css\""
        @merger.get_language_str(".js").must_equal "lang=\"javascript\""
        @merger.get_language_str(".sh").must_equal "lang=\"bash\""
        @merger.get_language_str(".bat").must_equal "lang=\"batch\""
        @merger.get_language_str(".xhtml").must_equal "lang=\"xml\""
        @merger.get_language_str(nil).must_equal "lang=\"ruby\""
        @merger.get_language_str("niaaa").must_equal  "lang=\"text\""
  end
  it "should delete and re-create the output directory" do
    FileUtils.mkdir_p 'output'
    out_f = File.new("output/temp.txt", 'w')
    out_f << "content"
    out_f.close
    @merger.clean_dirs
    File.exists?("output/temp.txt").must_equal false
  end
  it "should return the correctly formated output for an embedded file" do
    expected = %Q{<b>test/sample.rb</b>
<pre line="1" lang="ruby">
def sample
  println "sample"
end
</pre>
}
    expected.must_equal @merger.build_merged_file_content('test/sample.rb')
  end
  it "should process HTML and Markdown files" do
    @merger.process_files
    File.exists?("output/test/test.html").must_equal true
    File.exists?("output/test/test2.html").must_equal true
  end
end