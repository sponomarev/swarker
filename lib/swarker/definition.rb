module Swarker
  class Definition
    attr_reader :name, :object, :raw_data

    REQUIRED_FIELD   = 'required'.freeze
    PROPERTIES_FIELD = 'properties'.freeze
    REF              = '$ref'.freeze

    def initialize(name, raw_data)
      @name     = name
      @raw_data = raw_data
      move_required_fields
      fix_refs
    end

    private

    def move_required_fields
      requred_properties = raw_data.fetch(REQUIRED_FIELD)
      @object            = raw_data.reject { |k| k == REQUIRED_FIELD }

      requred_properties.each do |property|
        properties[property][REQUIRED_FIELD] = true
      end
    end

    def fix_refs
      properties.each_value do |property|
        property[REF].sub!(/.json#\//, '').sub!(/(\.\.\/)+/, '#/') if property[REF]
      end
    end

    def properties
      object[PROPERTIES_FIELD]
    end
  end
end
