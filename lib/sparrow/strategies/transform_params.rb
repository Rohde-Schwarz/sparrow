module Sparrow
  module Strategies
    class TransformParams
      attr_accessor :key_transformation_strategy

      def initialize(key_transformation_strategy_buzzword)
        key_transformation_strategy = create_key_transformation_strategy(
            key_transformation_strategy_buzzword)
        self.key_transformation_strategy = key_transformation_strategy
      end

      def transform(collection_or_hash)
        case collection_or_hash
        when Array
          collection_or_hash.map { |element| transform(element) }
        when Hash
          collection_or_hash.deep_transform_keys do |key|
            key_transformation_strategy.transform_key(key)
          end
        end
      end

      def create_key_transformation_strategy(key_transformation_strategy_buzzword)
        class_name = "#{key_transformation_strategy_buzzword.to_s}_key".camelize
        strategy_class = "Sparrow::Strategies::#{class_name}".constantize
        strategy_class.new
      end
    end
  end
end
