This project is used to help writing technical posts for wordpress.

To use this GEM I usually create a new directory for the post or post group project, then I create a Gemfile like this:

        source "http://rubygems.org"
        group :rake do
          gem "codemerger", "0.1.0", :require => "codemerger/rake_tasks"
        end

After that I create a Rakefile like this:

        require "rubygems"
        require "bundler/setup"
        Bundler.require :rake

Then just start creating the post file in the root directory, the project supports .html or .markdown files for the posts.
Inside this file, when I want to include a source sample, I create another file for the sample, and then I include it into the main post file with a code like this:

        {{full/path/to/the/file.rb}}

When the post is ready I run teh rake task:

        rake codemerger:merge

After that, the file I was writting is processed, a new file is created into the output directory and the sample source files are included with a code like this:

        <b>{{full/path/to/the/file.rb}}</b>
        <pre line="1" lang="ruby">
          ruby code
        </pre>

This snippet is then copied and pasted to a post into my wordpress blog, and the code gets colored using the plugin wp-syntax, and the output can be turned into PDF with the plugin wp-mpdf.

Today this gem supports source files in the following languages:

* Ruby (including Rakefile and Gemfile)
* Java
* YAML
* HTML
* XML
* Scala
* CSS
* Javascript
* Bash
* Batch

All other files are configures as "text".

For the next steps I'm planningto write more automated tests, refactor the language support code out, today it is a switch statement to convert from a file extension to a name supported by wp-syntax/Geshi and add support for templates and direct conversion of the source samples to colored HTML.

All these changes are simple, but besides the automated tests, I do not need any of the other right now, if you think they will be usefull for you, send me a message, file an enhancement request or fork, implement and send me a pull request.

Any testing or comments will be of great value, today, I think only I'm using this GEM.