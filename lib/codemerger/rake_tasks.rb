require "codemerger"
namespace "codemerger" do
  desc "Merge all the markdown files and the source files to create the output/post.html file"
  task :merge do
    @merger = Codemerger::Merger.new "."
    @merger.clean_dirs
    @merger.process_files
  end
end
