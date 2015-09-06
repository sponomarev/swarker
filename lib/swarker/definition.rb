module Swarker
  class Definition
    attr_reader :name, :schema

    REQUIRED_FIELD   = 'required'.freeze
    PROPERTIES_FIELD = 'properties'.freeze
    REF              = '$ref'.freeze

    def initialize(name, original_schema)
      @name            = name
      @original_schema = original_schema
      move_required_fields
      fix_refs
    end

    private

    def move_required_fields
      requred_properties = @original_schema.fetch(REQUIRED_FIELD)
      @schema            = @original_schema.reject { |k| k == REQUIRED_FIELD }

      requred_properties.each do |property|
        properties[property][REQUIRED_FIELD] = true
      end
    end

    def fix_refs
      properties.each_value do |property|
        property[REF].sub!(%r{.json#/}, '').sub!(%r{(\.\./)+}, '#/') if property[REF]
      end
    end

    def properties
      schema[PROPERTIES_FIELD]
    end
  end
end
