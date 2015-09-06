require 'uri'

module Swarker
  module Readers
    class ServiceReader
      attr_reader :services

      SERVICE_EXT  = '.service.yml'.freeze
      DEFAULT_PORT = 80

      def initialize(dir)
        @dir      = dir
        @services = read_services
      end

      private

      attr_reader :dir

      def read_services
        # TODO: read definitions
        # TODO: read paths

        hosts.collect do |host|
          Swarker::Service.new(host, original_schema)
        end
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
