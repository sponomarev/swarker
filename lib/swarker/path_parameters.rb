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
      in_request + in_path
    end

    def in_request
      # TODO: add logic for nested parameters
      accounted_request_params.collect do |parameter, options|
        {
          name:        parameter,
          description: options[:description],
          type:        options[:type],
          default:     options[:example],
          in:          determine_in(parameter)
        }
      end
    end

    def accounted_request_params
      @path_schema[:requestParameters][:properties]
    end

    def in_path
      accounted_path_params.collect do |parameter, default|
        {
          name:        parameter,
          description: '',       # nothing to propose for description
          type:        'string', # assume all path parameters are strings
          default:     default,
          in:          IN_QUERY, # path params are always in query
          required:    true
        }
      end
    end

    def accounted_path_params
      @path_schema[:extensions][:path_params].select { |k| !IGNORED_PATH_PARAMS.include?(k.to_sym) }
    end

    # TODO: add logic for formData
    def determine_in(_parameter)
      IN_QUERY
    end
  end
end
