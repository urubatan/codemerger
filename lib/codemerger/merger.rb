require 'fileutils'
require 'redcarpet'
require 'albino'

module Codemerger
  class HTMLwithAlbino < Redcarpet::Render::HTML
    include Redcarpet::Render::SmartyPants
    def code(code, language)
       code = code.gsub(/  /, "\t")
       code = code.gsub(/  /, "\t")
       result = if language
        %Q{<pre>#{Albino.new(code, language).colorize({O:"linenos=table,encoding=utf-8"})}</pre>}
      else
        %Q{<pre><code>#{code}</code></pre>}
      end
       result
    end
    def block_html(raw_html)
      @markdown ||= Redcarpet::Markdown.new(HTMLwithAlbino.new,
                                            :autolink => true, :space_after_headers => true, :superscript => true,
                                            :fenced_code_blocks => true, :tables => true, :no_intra_emphasis => true)
      m,tag,attrs,content = *(raw_html.match(/<(div)(.*?)>(.*)<\/div>/m))
      result = @markdown.render(content)
      %Q{<#{tag}#{attrs}>
         #{result}
        </#{tag}>
      }
    end
    def block_code(code, language)
       code = code.gsub(/  /, "\t")
       code = code.gsub(/  /, "\t")
       result = if language
        %Q{<pre>#{Albino.new(code, language).colorize({O:"linenos=table,encoding=utf-8"})}</pre>}
      else
        %Q{<pre><code>#{code}</code></pre>}
      end
      result
    end
  end
  class Merger
    attr_reader :markdown
    def initialize(dir_name)
      @dir_name = dir_name
    end
    def clean_dirs
      FileUtils.rm_rf 'output'
      FileUtils.mkdir_p 'output'
      FileUtils.mkdir_p "output/#{@dir_name}" if @dir_name != '.'
    end
    def get_language_str(ext)
      case ext
      when ".yml"; "yaml"
      when ".xml"; "xml"
      when ".html"; "xml"
      when ".rb"; "ruby"
      when ".java"; "java"
      when ".scala"; "scala"
      when ".erb"; "erb"
      when ".xsl"; "xslt"
      when ".css"; "css"
      when ".scss"; "scss"
      when ".coffee"; "coffeescript"
      when ".js"; "javascript"
      when ".sh"; "bash"
      when ".bat"; "batch"
      when ".xhtml"; "xml"
      when nil; "ruby"
      else; "text"
      end
    end
    def sanitize(fname)
      fname.gsub(/.*?:/, "")
    end
    def read_contents(fname)
      if fname =~ /.+:/
        `git cat-file blob #{fname}`
      else
        IO.readlines(fname).join('')
      end
    end
    def build_html_merged_file_content(f_name)
      ext = f_name[/(\.[a-zA-Z]+)/]
      lang_str = get_language_str(ext)
      %Q{
      <b>#{sanitize(f_name)}</b>
      <pre line="1" lang="#{lang_str}">
      #{read_contents(f_name)}
      </pre>
      }
    end
    def build_md_merged_file_content(f_name)
      ext = f_name[/(\.[a-zA-Z]+)/]
      lang_str = get_language_str(ext)
      %Q{_#{sanitize(f_name)}_

```#{lang_str}
#{read_contents(f_name)}
```
      }
    end
    def process_files
      in_files = Dir.glob("#{@dir_name}/**/*.{markdown,md,html}")
      in_files.sort.each do |file|
        in_lines = IO.readlines(file).join('')
        is_markdown = (file =~ /markdown$/) || (file =~ /md$/)
        out_fname = file[/^.*\./]
        out_f_name = "output/#{out_fname}html"
        out_d = File.dirname(out_f_name)
        FileUtils.mkdir_p out_d
        out_f    = File.new(out_f_name, 'w')
        if is_markdown
          in_lines.gsub!(/(\{\{[\/a-zA-Z0-9:_]+(?>\.[a-z:_A-Z0-9]{2,}){0,3}\}\})/) do |f_name_match|
            puts "Merging #{f_name_match}"
            f_name = f_name_match[2..-3]
            build_md_merged_file_content(f_name)
          end
          out_f << processMarkdown(in_lines)
        else
          out_f << in_lines.gsub(/(\{\{[\/a-zA-Z0-9_]+(?>\.[a-zA-Z0-9]{2,}){0,3}\}\})/) do |f_name_match|
            puts "Merging #{f_name_match}"
            f_name = f_name_match[2..-3]
            build_html_merged_file_content(f_name)
          end
        end
      end
    end
    def only_process_files(outdir="output")
      in_files = Dir.glob("#{@dir_name}/**/*.{markdown,md,html}")
      in_files.sort.each do |file|
        in_lines = IO.readlines(file).join('')
        puts "#{file} - #{in_lines.size}"
        is_markdown = (file =~ /markdown$/) || (file =~ /md$/)
        out_fname = file[/^.*\./]
        out_ext = "html"
        out_ext = "markdown" if is_markdown
        out_f_name = "#{outdir}/#{out_fname}#{out_ext}"
        out_d = File.dirname(out_f_name)
        FileUtils.mkdir_p out_d
        out_f    = File.new(out_f_name, 'w')
        if is_markdown
          out_f << in_lines.gsub(/(\{\{[\/a-zA-Z0-9:_]+(?>\.[a-z:_A-Z0-9]{2,}){0,3}\}\})/) do |f_name_match|
            #puts "Merging #{f_name_match}"
            f_name = f_name_match[2..-3]
            build_md_merged_file_content(f_name)
          end
        else
          out_f << in_lines.gsub(/(\{\{[\/a-zA-Z0-9_]+(?>\.[a-zA-Z0-9]{2,}){0,3}\}\})/) do |f_name_match|
            puts "Merging #{f_name_match}"
            f_name = f_name_match[2..-3]
            build_html_merged_file_content(f_name)
          end
        end
      end
    end
    def processMarkdown(text)
      @markdown ||= Redcarpet::Markdown.new(HTMLwithAlbino.new,
                                            :autolink => true, :space_after_headers => true, :superscript => true,
                                            :fenced_code_blocks => true, :tables => true, :no_intra_emphasis => true)
      result = @markdown.render(text)
      result
    end
  end
end
