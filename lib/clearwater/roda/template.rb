require 'fileutils'

module Clearwater
  module Roda
    class Template
      attr_reader :input, :output, :options

      def initialize input_filename, output_filename, options={}
        @input = input_filename
        @output = output_filename
        @options = options
      end

      def write
        if output.respond_to? :write
          output.write content
        else
          FileUtils.mkdir_p File.dirname(output)
          File.write output, content
        end
      end

      def content
        string = if input.respond_to? :read
                   input.read
                 else
                   File.read(input)
                 end

        string % options
      end
    end
  end
end
