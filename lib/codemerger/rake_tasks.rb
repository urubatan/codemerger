namespace "codemerger" do
  desc "Merge all the markdown files and the source files to create the output/post.html file"
  task :merge do
    require 'fileutils'
    FileUtils.rm_rf 'output'
    FileUtils.mkdir_p 'output'
    in_files = Dir.glob("*.{markdown,html}")
    in_files.sort.each do |file|
      in_lines = IO.readlines(file).to_s
      in_lines = Maruku.new(in_lines).to_html if file =~ /markdown$/
      out_fname = file[/^.*\./]
      out_f    = File.new("output/#{out_fname}html", 'w')
      out_f << in_lines.gsub(/(\{\{[\/a-zA-Z0-9_]+(?>\.[a-zA-Z0-9]{2,}){0,3}\}\})/) do |f_name_match|
        f_name = f_name_match[2..-3]
        ext = f_name[/(\.[a-zA-Z]+)/]
        lang_str = case ext
        when ".yml"; "lang=\"yaml\""
        when ".xml"; "lang=\"xml\""
        when ".html"; "lang=\"xml\""
        when ".rb"; "lang=\"ruby\""
        when ".java"; "lang=\"java\""
        when ".scala"; "lang=\"scala\""
        when ".erb"; "lang=\"ruby\""
        when ".xsl"; "lang=\"xml\""
        when ".css"; "lang=\"css\""
        when ".js"; "lang=\"javascript\""
        when ".sh"; "lang=\"bash\""
        when ".bat"; "lang=\"batch\""
        when ".xhtml"; "lang=\"xml\""
        when nil; "lang=\"ruby\""
        else; "lang=\"text\""
        end
        
        <<_EOF_
<b>#{f_name}</b>
<pre line="1" #{lang_str}>
#{IO.readlines(f_name).to_s}
</pre>
_EOF_
        end
    end
  end
end
