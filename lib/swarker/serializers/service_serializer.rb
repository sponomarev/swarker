module Swarker
  module Serializers
    class ServiceSerializer
      attr_reader :schema

      def initialize(service)
        @service = service
        @schema  = build_hash
      end

      private

      attr_reader :service

      def build_hash
        service.schema.merge(nested_objects)
      end

      def nested_objects
        {
          definitions: objects_hash(service.definitions),
          paths:       objects_hash(service.paths)
        }
      end

      def objects_hash(objects)
        objects.each_with_object({}) do |object, result|
          result[object.name] ||= HashWithIndifferentAccess.new
          result[object.name].merge!(object.schema)
        end
      end

      def to_json
        schema.to_json
      end
    end
  end
end
