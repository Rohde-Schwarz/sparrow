require 'camel_caser/strategies/transform_params'
require 'camel_caser/strategies/json_format_strategies/json_format_strategy'

module CamelCaser
  module Transformable
    def transform_params
      transform_params          = CamelCaser::Strategies::TransformParams
      transform_params_strategy = transform_params.new(transform_strategy)
      transform_params_strategy.transform(ensure_json)
    end

    def transform_strategy
      default  =
          CamelCaser.configuration.default_json_key_transformation_strategy(type)
      strategy = json_format || default
      strategy.to_sym
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
      if respond_to?(:env) then
        env[CamelCaser.configuration.json_format_header(type)]
      else
        nil
      end
    end

    def ensure_json
      json_params = unless params.is_a?(Hash)
                      CamelCaser::Strategies::JsonFormatStrategy.convert(params)
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
  end
end
