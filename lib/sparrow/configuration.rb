module Sparrow
  # Middleware configuration store
  # see {https://github.com/GateprotectGmbH/sparrow#configuration}
  class Configuration
    attr_accessor :json_request_format_header,
                  :json_response_format_header,
                  :excluded_routes,
                  :default_json_request_key_transformation_strategy,
                  :default_json_response_key_transformation_strategy,
                  :camelize_ignore_uppercase_keys,
                  :allowed_content_types,
                  :allowed_accepts,
                  :enable_logging,
                  :ignored_response_codes,
                  :camelize_strategy

    ##
    # Initializes a new Configuration with default parameters
    def initialize
      @enable_logging                                    = false
      @json_request_format_header                        = 'request-json-format'
      @json_response_format_header                       = 'response-json-format'
      @excluded_routes                                   = []
      @default_json_request_key_transformation_strategy  = :underscore
      @default_json_response_key_transformation_strategy = :camelize
      @camelize_ignore_uppercase_keys                    = true
      @allowed_content_types                             = %w[
        application/json
        application/x-www-form-urlencoded
        text/x-json
      ]

      @allowed_accepts        = @allowed_content_types + [nil]
      @ignored_response_codes = [404] + (500..511).to_a
      @camelize_strategy      = :lower
    end

    ##
    # @param type [String] the http message type.
    #   Must be either 'request' or 'response'.
    # @return [String] the configuration value for the json_format_header for
    #   the given http message type
    def json_format_header(type)
      public_send("json_#{type}_format_header")
    end

    ##
    # the default json_key_transformation_strategy option for the given
    # http message type
    # @param type [String] http message type. Must be either 'request' or
    #   'response'
    # @return [String] the configuration option value
    def default_json_key_transformation_strategy(type)
      public_send("default_json_#{type}_key_transformation_strategy")
    end
  end
end
