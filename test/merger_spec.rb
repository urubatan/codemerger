require "minitest/autorun"
require "codemerger"
describe Codemerger::HTMLwithAlbino do
  def setup
    @colorer = Codemerger::HTMLwithAlbino.new
  end
  it "should suround code without language" do
    @colorer.code("mycode", nil).must_equal "<pre><code>mycode</code></pre>"
  end
  it "should suround code blocs without language" do
    @colorer.block_code("mycode", nil).must_equal "<pre><code>mycode</code></pre>"
  end
  it "should colorize blocks inside HTML" do
    @colorer.block_html('<div class="codetest">
## test

```
def abc
  puts "test"
end
```

</div>') # .must_equal %q{<div class="codetest">
    #         <h2>test</h2>
    # <pre><code>def abc
    #  puts "test"
    # end
    # </code></pre>
    #        </div>
    #      }
  end
end

describe Codemerger::Merger do
  def setup
    @merger = Codemerger::Merger.new "test"
  end
  it "should return the correct language string" do
    @merger.get_language_str(".yml").must_equal "yaml"
    @merger.get_language_str(".xml").must_equal "xml"
    @merger.get_language_str(".html").must_equal "xml"
    @merger.get_language_str(".rb").must_equal "ruby"
    @merger.get_language_str(".java").must_equal "java"
    @merger.get_language_str(".scala").must_equal "scala"
    @merger.get_language_str(".erb").must_equal "erb"
    @merger.get_language_str(".xsl").must_equal "xslt"
    @merger.get_language_str(".css").must_equal "css"
    @merger.get_language_str(".js").must_equal "javascript"
    @merger.get_language_str(".sh").must_equal "bash"
    @merger.get_language_str(".bat").must_equal "batch"
    @merger.get_language_str(".xhtml").must_equal "xml"
    @merger.get_language_str(nil).must_equal "ruby"
    @merger.get_language_str("niaaa").must_equal "text"
    @merger.get_language_str(".coffee").must_equal "coffeescript"
    @merger.get_language_str(".scss").must_equal "scss"
  end
  it "should delete and re-create the output directory" do
    FileUtils.mkdir_p "output"
    out_f = File.new("output/temp.txt", "w")
    out_f << "content"
    out_f.close
    @merger.clean_dirs
    File.exist?("output/temp.txt").must_equal false
  end
  it "should return the correctly formated output for an embedded file" do
    expected = %(
      <b>test/sample.rb</b>
      <pre line="1" lang="ruby">
			def sample
	println "sample"
end
      </pre>
      )
    actual = @merger.build_html_merged_file_content("test/sample.rb")
    # expected.must_equal actual
  end
  it "should process HTML and Markdown files" do
    @merger.process_files
    File.exist?("output/test/test.html").must_equal true
    File.exist?("output/test/test2.html").must_equal true
    puts File.new("output/test/test2.html").read
  end
end
