module Sparrow
  ##
  # Encapsulates json transform methods. This is basically the core entry point
  # for all conversions done by the middleware.
  module Transformable
    ##
    # Does the conversion based on the selected strategy and HTTP header
    # parameters provided
    def transform_params
      transform_params_strategy.transform(ensure_json)
    end

    def handle
      transform_query_string
    end

    def json_body
      json = parsable_json_string(transform_params)
      MultiJson.load(json)
      json
    rescue MultiJson::ParseError
      MultiJson.dump(ensure_json)
    end

    private

    def json_format
      if respond_to?(:env)
        env[Sparrow.configuration.json_format_header(type)]
      else
        nil
      end
    end

    # Make sure we are always dealing with a Ruby representation of a JSON
    # String, i.e. a Hash
    def ensure_json
      json_params = if !params.is_a?(Hash)
                      Sparrow::Strategies::JsonFormatStrategy.convert(params)
                    elsif params.is_a?(Hash) &&
                        params.values.compact.empty? &&
                        params.keys.one?
                      params.keys.first
                    else
                      params
                    end
      return MultiJson.load(json_params) if json_params.is_a?(String)
      json_params
    end

    def parsable_json_string(transformable_params)
      if [Hash, Array].include? transformable_params.class
        MultiJson.dump(transformable_params)
      else
        transformable_params
      end
    end

    def transform_params_strategy
      transform_strategy_options = {
          camelize_ignore_uppercase_keys: Sparrow.configuration.camelize_ignore_uppercase_keys,
          camelize_strategy:              Sparrow.configuration.camelize_strategy

      }
      transform_params           = Sparrow::Strategies::TransformParams
      transform_params.new(transform_strategy, transform_strategy_options)
    end

    ##
    # Usualy Query String parameters want to get transformed as well
    def transform_query_string
      env_query_hash      = Rack::Utils.parse_nested_query(env['QUERY_STRING'])
      transformed_hash    = transform_params_strategy.transform(env_query_hash)
      env['QUERY_STRING'] = transformed_hash.to_param
    end

    def transform_strategy
      default  =
          Sparrow.configuration.default_json_key_transformation_strategy(type)
      strategy = json_format || default
      strategy.to_sym
    end
  end
end
