module Swarker
  class Path
    attr_reader :name, :schema

    DEFAULT_SCHEMA = {
      produces: ['application/json'.freeze]
    }

    def initialize(name, original_schema, preparsed = false)
      @name            = name
      @original_schema = HashWithIndifferentAccess.new(original_schema)
      @preparsed       = preparsed

      parse_schema
    end

    def verb
      # Lurker schema has only one request verb per file
      @verb ||= @preparsed ? @schema.keys.first : original_schema[:extensions][:method].downcase
    end

    private

    attr_reader :original_schema, :preparsed
    alias_method :preparsed?, :preparsed

    def parse_schema
      @schema = preparsed? ? @original_schema : create_schema
    end

    def create_schema
      HashWithIndifferentAccess.new(verb => DEFAULT_SCHEMA.merge(computed_schema))
    end

    def computed_schema
      {
        description: original_schema[:description],
        tags:        [original_schema[:description]],
        parameters:  parameters,
        responses:   responses
      }
    end

    # TODO: add logic for name parameters
    def parameters
      @original_schema[:requestParameters][:properties].collect do |parameter, options|
        {
          name:        parameter,
          description: options[:description],
          type:        options[:type],
          default:     options[:example],
          in:          determine_in(parameter)
        }
      end
    end

    def responses
      {
        response_code => {
          description: '',
          schema:      response_schema
        }
      }
    end

    def response_code
      # Lurker schema has only one response code per file
      @original_schema[:responseCodes].first[:status].to_s
    end

    def response_schema
      response_schema = @original_schema[:responseParameters].dup
      response_schema[:items].reject! { |k| k.to_sym == :required } if response_schema[:items]

      response_schema['$ref'].sub!(%r{.json#/}, '').sub!(%r{(\.\./)+}, '#/') if response_schema['$ref']

      response_schema
    end

    # TODO: add logic for formData
    def determine_in(_parameter)
      'query'.freeze
    end
  end
end
