module Swarker
  class Schema
    DEFAULT_SCHEMA = {
      swagger:  '2.0',
      consumes: 'application/json',
      produces: 'application/json',
      info:     {
        version: '1.0'
      }
    }

    attr_reader :host, :title

    def initialize(title: nil, host: nil)
      @host  = host
      @title = title
    end

    def swagger
      DEFAULT_SCHEMA[:swagger]
    end

    def consumes
      DEFAULT_SCHEMA[:consumes]
    end

    def produces
      DEFAULT_SCHEMA[:produces]
    end

    def version
      DEFAULT_SCHEMA[:info][:version]
    end

    def definitions
    end

    def paths
    end
  end
end
