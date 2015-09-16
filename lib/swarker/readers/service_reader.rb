require 'uri'
require 'active_support/core_ext/object/blank'

module Swarker
  module Readers
    class ServiceReader
      attr_reader :services

      SERVICE_EXT     = '.service.yml'.freeze
      DEFAULT_PORT    = 80
      DEFINITIONS_DIR = 'definitions'.freeze
      PATHS_DIR       = 'api'.freeze

      def initialize(dir, subtree = nil)
        @dir     = dir
        @subtree = subtree

        @services = read_services
      end

      private

      attr_reader :dir, :subtree

      def read_services
        hosts.collect do |host|
          Swarker::Service.new(host, original_schema, definitions, paths)
        end.presence || [local_service]
      end

      def local_service
        Swarker::Service.new(nil, original_schema, definitions, paths)
      end

      def definitions
        @definitions ||= DefinitionsReader.new(definitions_dir).definitions
      end

      def definitions_dir
        File.join(dir, DEFINITIONS_DIR)
      end

      def paths
        @paths ||= PathsMerger.new(PathsReader.new(paths_dir).paths).paths
      end

      def paths_dir
        File.join(dir, subtree || PATHS_DIR)
      end

      def hosts
        original_schema[:domains].values.collect do |domain|
          uri = URI(domain)
          uri.port == DEFAULT_PORT ? uri.host : "#{uri.host}:#{uri.port}"
        end
      end

      def original_schema
        @original_schema ||= HashWithIndifferentAccess.new(YAML.load_file(service_file))
      end

      def service_file
        # Assumes that it can be only one service file in service directory
        Dir["#{dir}/*#{SERVICE_EXT}"].first
      end
    end
  end
end
