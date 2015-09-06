module Swarker
  class PathParameters
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

    # TODO: add logic for `extensions/path_params`
    def path_parameters
      []
    end

    # TODO: add logic for formData
    def determine_in(_parameter)
      'query'.freeze
    end
  end
end
