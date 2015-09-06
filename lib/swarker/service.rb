module Swarker
  class Service
    DEFAULT_SCHEMA = {
      swagger:  '2.0'.freeze,
      consumes: 'application/json'.freeze,
      produces: 'application/json'.freeze,
      info:     { version: '1.0'.freeze }
    }

    attr_reader :host, :schema, :definitions, :paths

    def initialize(host, original_schema, definitions = [], paths = [])
      @host            = host
      @original_schema = HashWithIndifferentAccess.new(original_schema)
      @definitions     = definitions
      @paths           = paths

      parse_schema
    end

    private

    attr_reader :original_schema

    def parse_schema
      @schema = HashWithIndifferentAccess.new(DEFAULT_SCHEMA.deep_merge(computed_schema))
    end

    def computed_schema
      { info: { title: original_schema[:name] } }
    end
  end
end
