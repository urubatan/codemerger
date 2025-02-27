require "fileutils"
require "kramdown"
require "rouge"

module Codemerger
  class Merger
    def initialize(dir_name)
      @dir_name = dir_name
    end

    def clean_dirs
      FileUtils.rm_rf "output"
      FileUtils.mkdir_p "output"
      FileUtils.mkdir_p "output/#{@dir_name}" if @dir_name != "."
    end

    def get_language_str(ext)
      case ext
      when ".yml" then "yaml"
      when ".xml" then "xml"
      when ".html" then "xml"
      when ".rb" then "ruby"
      when ".java" then "java"
      when ".scala" then "scala"
      when ".erb" then "erb"
      when ".xsl" then "xslt"
      when ".css" then "css"
      when ".scss" then "scss"
      when ".coffee" then "coffeescript"
      when ".js" then "javascript"
      when ".sh" then "bash"
      when ".bat" then "batch"
      when ".xhtml" then "xml"
      when nil then "ruby"
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
        IO.readlines(fname).join("")
      end
    end

    def build_html_merged_file_content(f_name)
      ext = f_name[/(\.[a-zA-Z]+)/]
      lang_str = get_language_str(ext)
      %(
      <b>#{sanitize(f_name)}</b>
      <pre line="1" lang="#{lang_str}">
      #{read_contents(f_name)}
      </pre>
      )
    end

    def build_md_merged_file_content(f_name)
      ext = f_name[/(\.[a-zA-Z]+)/]
      if ext =~ /^(md|markdown)$/
        lang_str = get_language_str(ext)
        %(_#{sanitize(f_name)}_{:.code-title}

~~~ #{lang_str}
#{read_contents(f_name)}
~~~
      )
      else
        %(

#{read_contents(f_name)}

        )
      end
    end

    def process_files(html: false)
      in_files = if html
                   Dir.glob("#{@dir_name}/**/*.{markdown,md,html}")
                 else
                   Dir.glob("#{@dir_name}/**/*.{markdown,md}")
                 end
      in_files.sort.each do |file|
        in_lines = IO.readlines(file).join("")
        is_markdown = (file =~ /markdown$/) || (file =~ /md$/)
        out_fname = file[/^.*\./]
        out_f_name = "output/#{out_fname}html"
        out_d = File.dirname(out_f_name)
        FileUtils.mkdir_p out_d
        File.open(out_f_name, "w:utf-8") do |out_f|
          if is_markdown
            in_lines.gsub!(%r{(\{\{[/a-zA-Z0-9:_]+(?>\.[a-z:_A-Z0-9]{2,}){0,3}\}\})}) do |f_name_match|
              puts "Merging #{f_name_match}"
              f_name = f_name_match[2..-3]
              build_md_merged_file_content(f_name)
            end
            out_f << process_markdown(in_lines)
          else
            out_f << in_lines.gsub(%r{(\{\{[/a-zA-Z0-9_]+(?>\.[a-zA-Z0-9]{2,}){0,3}\}\})}) do |f_name_match|
              puts "Merging #{f_name_match}"
              f_name = f_name_match[2..-3]
              build_html_merged_file_content(f_name)
            end
          end
        end
      end
    end

    def process_markdown(text)
      template = "string://#{File.read(File.join(File.dirname(File.expand_path(__FILE__)), 'document_with_css.html.erb'))}"
      doc = Kramdown::Document.new(text, syntax_highlighter: :rouge, header_links: true, auto_ids: true, template: template)
      doc.to_html
    end
  end
end
