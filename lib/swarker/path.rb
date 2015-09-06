module Swarker
  # FIXME: maybe some refactor?
  class Path
    attr_reader :name, :schema

    DEFAULT_SCHEMA = {
      produces: ['application/json'.freeze]
    }

    def initialize(name, original_schema, preparsed = false)
      @name            = name
      @original_schema = HashWithIndifferentAccess.new(original_schema)
      @preparsed       = preparsed

      if preparsed
        @schema = @original_schema
      else
        @schema = HashWithIndifferentAccess.new
        parse_schema
      end
    end

    def verb
      @preparsed ? @schema.keys.first : original_schema[:extensions][:method].downcase
    end

    private

    attr_reader :original_schema

    def parse_schema
      @schema[verb] = DEFAULT_SCHEMA.merge(computed_schema)
    end

    def computed_schema
      {
        description: description,
        tags:        tags,
        parameters:  parameters,
        responses:   responses
      }
    end

    def description
      original_schema[:description]
    end

    def tags
      [description]
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
