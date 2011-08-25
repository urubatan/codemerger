require 'fileutils'
require 'redcarpet'
require 'albino'

module Codemerger
  class HTMLwithAlbino < Redcarpet::Render::HTML
    def block_code(code, language)
      Albino.colorize(code, language)
    end
  end
  class Merger
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
    end
    def build_merged_file_content(f_name)
      ext = f_name[/(\.[a-zA-Z]+)/]
      lang_str = get_language_str(ext)
      %Q{
      <b>#{f_name}</b>
      <pre line="1" #{lang_str}>
      #{IO.readlines(f_name).join('')}
      </pre>
      }
    end
    def process_files
      in_files = Dir.glob("#{@dir_name}/*.{markdown,html}")
      in_files.sort.each do |file|
        in_lines = IO.readlines(file).join('')
        in_lines = processMarkdown(in_lines) if file =~ /markdown$/
        out_fname = file[/^.*\./]
        out_f    = File.new("output/#{out_fname}html", 'w')
        out_f << in_lines.gsub(/(\{\{[\/a-zA-Z0-9_]+(?>\.[a-zA-Z0-9]{2,}){0,3}\}\})/) do |f_name_match|
          f_name = f_name_match[2..-3]
          build_merged_file_content(f_name)
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
