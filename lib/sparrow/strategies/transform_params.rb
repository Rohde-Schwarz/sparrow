module Sparrow
  module Strategies
    ##
    # Core class to trigger the conversion
    class TransformParams
      ##
      # the strategy stating how to convert the JSON
      # @return [KeyTransformation] key transformation strategy
      # @see #initialize
      attr_accessor :key_transformation_strategy

      ##
      # Key Transformation Strategy options. Possible values differ by
      # the specific strategy. E.g. for CamelizeKey options may be
      # the strategy and camlize_uppercase_params
      # @see KeyTransformationStrategy::CamelizeKey
      # @see KeyTransformationStrategy::UnderscoreKey
      attr_accessor :options

      ##
      # Create a new TransformParams instance
      # @param [String] key_transformation_strategy_buzzword the strategy
      #   buzzword stating how to transform. Must be either 'camelize' or
      #   'underscore'
      # @param [Hash] options options for the key transformation strategy
      def initialize(key_transformation_strategy_buzzword, options = {})
        self.options                     = options
        key_transformation_strategy      = create_key_transformation_strategy(
        key_transformation_strategy_buzzword)
        self.key_transformation_strategy = key_transformation_strategy
      end

      ##
      # Do the transformation
      # @param [Array|Hash] collection_or_hash the object to be transformed
      #   if it is an Array each object inside of it will be transformed, i.e.
      #   each Hash's keys
      #   if it is a Hash each key will be transformed. Recursively.
      # @return [Array|Hash] the transformed input
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

      private

      def create_key_transformation_strategy(key_transformation_strategy)
        class_name = "#{key_transformation_strategy.to_s}_key"
        class_name = class_name.camelize
        full_strategy_class_name =
            "Sparrow::Strategies::KeyTransformation::#{class_name}"
        strategy_class           = full_strategy_class_name.constantize
        strategy_class.new(options)
      end
    end
  end
end
