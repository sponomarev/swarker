module Swarker
  class PathParameters
    IGNORED_PATH_PARAMS = [:controller, :action]
    IN_QUERY            = 'query'.freeze

    attr_reader :parameters

    def initialize(path_schema)
      @path_schema = HashWithIndifferentAccess.new(path_schema)

      @parameters = parse_parameters
    end

    private

    def parse_parameters
      request_parameters + path_parameters
    end

    def request_parameters
      # TODO: add logic for nested parameters
      @path_schema[:requestParameters][:properties].collect do |parameter, options|
        {
          name:        parameter,
          description: options[:description],
          type:        options[:type],
          default:     options[:example],
          in:          determine_in(parameter)
        }
      end
    end

    def path_parameters
      @path_schema[:extensions][:path_params].select { |k, v| !IGNORED_PATH_PARAMS.include?(k.to_sym) }.collect do |parameter, default|
        {
          name:        parameter,
          description: '',       # nothing to propose for description
          type:        'string', # assume all path parameters are strings
          default:     default,
          in:          IN_QUERY,  # path params are always in query
          required:    true
        }
      end
    end

    # TODO: add logic for formData
    def determine_in(_parameter)
      IN_QUERY
    end
  end
end
