module Swarker
  # FIXME: maybe some refactor?
  class Path
    attr_reader :name, :schema

    DEFAULT_SCHEME = {
      'produces' => ['application/json']
    }

    def initialize(name, original_schema, preparsed = false)
      @name            = name
      @original_schema = original_schema
      @preparsed       = preparsed

      if preparsed
        @schema = @original_schema
      else
        @schema = {}
        parse_scheme
      end
    end

    def verb
      @preparsed ? @schema.keys.first : original_schema['extensions']['method'].downcase
    end

    private

    attr_reader :original_schema

    def parse_scheme
      @schema[verb] = DEFAULT_SCHEME.merge(computed_scheme)
    end

    def computed_scheme
      {
        'description' => description,
        'tags'        => tags,
        'parameters'  => parameters,
        'responses'   => responses
      }
    end

    def description
      original_schema['description']
    end

    def tags
      [description]
    end

    # TODO: add logic for name parameters
    def parameters
      @original_schema['requestParameters']['properties'].collect do |parameter, options|
        {
          'name'        => parameter,
          'description' => options['description'],
          'type'        => options['type'],
          'default'     => options['example'],
          'in'          => determine_in(parameter)
        }
      end
    end

    def responses
      {
        response_code => {
          'description' => '',
          'schema'      => response_schema
        }
      }
    end

    def response_code
      @original_schema['responseCodes'].first['status'].to_s
    end

    def response_schema
      response_schema = @original_schema['responseParameters'].dup
      response_schema['items'].reject! { |k| k == 'required' } if response_schema['items']

      response_schema
    end

    # TODO: add logic for formData
    def determine_in(_parameter)
      'query'
    end
  end
end
