module Swarker
  class Path
    attr_reader :path, :scheme

    DEFAULT_SCHEME = {
      'produces' => ['application/json']
    }

    def initialize(path, original_scheme)
      @path            = path
      @original_scheme = original_scheme
      @scheme          = {}
      parse_scheme
    end


    def verb
      original_scheme['extensions']['method'].downcase
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

    def determine_in(_parameter)
      'query'
    end
  end
end
