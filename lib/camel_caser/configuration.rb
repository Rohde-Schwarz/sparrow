module CamelCaser
  class Configuration
    attr_accessor :json_request_format_header,
                  :json_response_format_header,
                  :excluded_routes,
                  :default_json_request_key_transformation_strategy,
                  :default_json_response_key_transformation_strategy

    def initialize
      @json_request_format_header                        = 'request-json-format'
      @json_response_format_header                       = 'response-json-format'
      @excluded_routes                                   = []
      @default_json_request_key_transformation_strategy  = :camelize
      @default_json_response_key_transformation_strategy = :camelize
    end

    def json_format_header(type)
      send("json_#{type}_format_header")
    end

    def default_json_key_transformation_strategy(type)
      send("default_json_#{type}_key_transformation_strategy")
    end
  end
end
