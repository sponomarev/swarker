module Swarker
  class PathParameters
    IGNORED_PATH_PARAMS = [:controller, :action]
    IN_QUERY            = 'query'.freeze
    IN_FORM_DATA        = 'formData'.freeze
    REF                 = '$ref'.freeze

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
        param_desc            = {
          name:        parameter,
          description: options[:description] || '', # blank unless given
          type:        options[:type],
          default:     options[:example],
          in:          determine_in(parameter)
        }.compact

        param_desc[:required] = true if require_request_params.include?(parameter)
        param_desc[REF]       = options[REF].sub(%r{.json#/}, '').sub(%r{(\.\./)+}, '#/') if options[REF]

        param_desc
      end
    end

    def accounted_request_params
      @path_schema[:requestParameters][:properties]
    end

    def require_request_params
      @path_schema[:requestParameters][:required] || []
    end

    def in_path
      accounted_path_params.collect do |parameter, default|
        {
          name:        parameter,
          description: '', # nothing to propose for description
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

    def determine_in(_parameter)
      case (verb)
      when 'get'
        IN_QUERY
      else
        query_params.include?(_parameter) ? IN_QUERY : IN_FORM_DATA
      end
    end

    def verb
      @path_schema[:extensions][:method].downcase
    end

    def query_params
      @path_schema[:extensions][:query_params] || []
    end
  end
end
