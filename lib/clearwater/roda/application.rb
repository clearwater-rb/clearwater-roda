require 'fileutils'

require 'clearwater/roda/template'

module Clearwater
  module Roda
    class Application
      DirectoryAlreadyExists = Class.new(StandardError)

      attr_reader :name

      def initialize name
        @name = name
        @previous_dirs = []
      end

      def build
        dir_must_not_exist!

        mkdir
        chdir
        write_files
        bundle
        git_init
        git_commit
        chdir_back

        puts
        puts <<-EOF
Thanks for using Clearwater::Roda!

To run your new app:

    $ cd #{dir_name}
    $ ./dev

Then point your browser to http://localhost:9292/

The Clearwater app lives in #{Dir.pwd}/#{dir_name}/assets/js/app.rb. To compile
your assets for production, simply run:

    $ rake assets:precompile

        EOF
      end

      def mkdir
        FileUtils.mkdir_p dir_name
      end

      def chdir
        @previous_dirs.push Dir.pwd
        FileUtils.chdir dir_name
      end

      def chdir_back
        FileUtils.chdir @previous_dirs.pop
      end

      def bundle
        system "bundle -j12"
      end

      def git_init
        `git init`
      end

      def git_commit
        `git add --all .`
        `git commit -m 'Hello world!'`
      end

      def write_files
        files = %W(
          Gemfile
          config.ru
          assets/js/app.rb
          dev
          Rakefile
        )
        
        files.each do |template_name|
          Template.new(
            template_path(template_name),
            template_name,
            template_options,
          ).write
        end

        app_filename = "#{underscore(name)}.rb"
        Template.new(
          template_path('app.rb'),
          app_filename,
          template_options,
        ).write

        FileUtils.chmod 0744, 'dev'
      end

      def template_options
        {
          underscored_name: dir_name,
          titleized_name: class_name,
        }
      end

      def template_path(name)
        "#{File.expand_path('../../../../templates', __FILE__)}/#{name}"
      end

      def underscore name
        name.gsub(/\w[A-Z]/) { |match| "#{match[0]}_#{match[1]}" }.downcase
      end

      def titleize name
        name = name.gsub(/_[a-z]/) { |match| match[1].upcase }
        name[0] = name[0].upcase
        name
      end

      def dir_must_not_exist!
        if File.exist? dir_name
          raise DirectoryAlreadyExists, "directory #{dir_name} already exists!"
        end
      end

      def class_name
        titleize name
      end

      def dir_name
        underscore name
      end
    end
  end
end
