module Sparrow
  module Transformable
    def transform_params
      transform_params_strategy.transform(ensure_json)
    end

    def transform_strategy
      default  =
          Sparrow.configuration.default_json_key_transformation_strategy(type)
      strategy = json_format || default
      strategy.to_sym
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

    def ensure_json
      json_params = if !params.is_a?(Hash)
                      Sparrow::Strategies::JsonFormatStrategy.convert(params)
                    elsif params.is_a?(Hash) && params.values == [nil] &&
                      params.keys.length == 1
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
      transform_params = Sparrow::Strategies::TransformParams
      transform_params.new(transform_strategy)
    end

    def transform_query_string
      env_query_hash      = Rack::Utils.parse_nested_query(env['QUERY_STRING'])
      transformed_hash    = transform_params_strategy.transform(env_query_hash)
      env['QUERY_STRING'] = transformed_hash.to_param
    end

  end
end
