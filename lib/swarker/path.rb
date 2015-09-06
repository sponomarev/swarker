module Swarker
  # FIXME: maybe some refactor?
  class Path
    attr_reader :name, :scheme

    DEFAULT_SCHEME = {
      'produces' => ['application/json']
    }

    def initialize(name, original_scheme, preparsed = false)
      @name            = name
      @original_scheme = original_scheme
      @preparsed       = preparsed

      if preparsed
        @scheme = @original_scheme
      else
        @scheme = {}
        parse_scheme
      end
    end

    def verb
      @preparsed ? @scheme.keys.first : original_scheme['extensions']['method'].downcase
    end

    private

    attr_reader :original_scheme

    def parse_scheme
      @scheme[verb] = DEFAULT_SCHEME.merge(computed_scheme)
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
      original_scheme['description']
    end

    def tags
      [description]
    end

    # TODO: add logic for name parameters
    def parameters
      @original_scheme['requestParameters']['properties'].collect do |parameter, options|
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
      @original_scheme['responseCodes'].first['status'].to_s
    end

    def response_schema
      schema = @original_scheme['responseParameters'].dup
      schema['items'].reject! { |k| k == 'required' } if schema['items']

      schema
    end

    # TODO: add logic for formData
    def determine_in(_parameter)
      'query'
    end
  end
end
