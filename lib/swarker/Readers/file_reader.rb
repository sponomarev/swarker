require 'erb'
require 'json'
require 'yaml'

module Swarker
  module Readers
    class FileReader
      attr_reader :path

      JSON_EXT = '.json'.freeze
      YAML_EXT = '.yml'.freeze
      ERB_EXT  = '.erb'.freeze

      def initialize(path)
        @path = path
      end

      def read
        case File.extname(path)
        when JSON_EXT
          read_json
        when YAML_EXT
          read_yaml
        when ERB_EXT
          read_erb
        end
      end

      private

      def read_json
        JSON.parse(File.read(path))
      end

      def read_yaml
        YAML.load_file(path)
      end

      def read_erb
        YAML.load(ERB.new(File.read(path)).result)
      end
    end
  end
end
