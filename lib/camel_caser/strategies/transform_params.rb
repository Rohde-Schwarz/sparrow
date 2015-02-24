require 'active_support/core_ext/string'
if ActiveSupport::VERSION::STRING.match(/3\.\d+\.\d+/)
  require 'camel_caser/core_ext/hash'
end

require 'camel_caser/strategies/key_transformation/underscore_key'
require 'camel_caser/strategies/key_transformation/camelize_key'

module CamelCaser
  module Strategies
    class TransformParams
      attr_accessor :key_transformation_strategy

      def initialize(key_transformation_strategy_buzzword)
        key_transformation_strategy = create_key_transformation_strategy(
            key_transformation_strategy_buzzword)
        self.key_transformation_strategy = key_transformation_strategy
      end

      def transform(json_params)
        return json_params unless json_params.is_a?(Hash)
        json_params.deep_transform_keys do |key|
          key_transformation_strategy.transform_key(key)
        end
      end

      def create_key_transformation_strategy(key_transformation_strategy_buzzword)
        class_name = "#{key_transformation_strategy_buzzword.to_s}_key".camelize
        strategy_class = "CamelCaser::Strategies::#{class_name}".constantize
        strategy_class.new
      end
    end
  end
end