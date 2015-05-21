module Sparrow
  class Configuration
    attr_accessor :json_request_format_header,
                  :json_response_format_header,
                  :excluded_routes,
                  :default_json_request_key_transformation_strategy,
                  :default_json_response_key_transformation_strategy,
                  :camelize_ignore_uppercase_keys,
                  :allowed_content_types,
                  :allowed_accepts

    def initialize
      @json_request_format_header                        = 'request-json-format'
      @json_response_format_header                       = 'response-json-format'
      @excluded_routes                                   = []
      @default_json_request_key_transformation_strategy  = :camelize
      @default_json_response_key_transformation_strategy = :camelize
      @camelize_ignore_uppercase_keys                    = true
      @allowed_content_types                             = %w[
        application/json
        application/x-www-form-urlencoded
        text/x-json
      ]

      @allowed_accepts = @allowed_content_types + [nil]
    end

    def json_format_header(type)
      public_send("json_#{type}_format_header")
    end

    def default_json_key_transformation_strategy(type)
      public_send("default_json_#{type}_key_transformation_strategy")
    end
  end
end
