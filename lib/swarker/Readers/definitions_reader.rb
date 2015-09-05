require 'pathname'

module Swarker
  module Readers
    class DefinitionsReader
      attr_reader :definitions

      def initialize(dir)
        @definitions = read_definitions(dir)
      end

      private

      def read_definitions(dir)
        definitions_paths(dir).collect do |path|
          Swarker::Definition.new(definitions_name(path), FileReader.new(path).read)
        end
      end

      def definitions_name(path)
        File.basename(path).scan(/\A\w+/).first
      end

      def definitions_paths(dir)
        Dir["#{dir}/**/*.json"] + Dir["#{dir}/**/*.json.yml"] + Dir["#{dir}/**/*.json.yml.erb"]
      end
    end
  end
end
