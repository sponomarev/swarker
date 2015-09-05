require 'pathname'

module Swarker
  module Readers
    class PathsReader
      attr_reader :paths

      def initialize(dir)
        @paths = read_paths(dir)
      end

      private

      def read_paths(dir)
        paths_files(dir).collect do |file|
          Swarker::Path.new(path_name(dir, file), FileReader.new(file).read)
        end
      end

      def path_name(dir, file_path)
        file_path.sub(base_dir(dir), '').scan(%r{\A[\/\w]+}).first.gsub(/__(\w+)/, '{\1}') + '.json'
      end

      def paths_files(dir)
        Dir["#{dir}/**/*.json"] + Dir["#{dir}/**/*.json.yml"] + Dir["#{dir}/**/*.json.yml.erb"]
      end

      def base_dir(dir)
        dir.split('/').slice(0..-2).join('/')
      end
    end
  end
end
