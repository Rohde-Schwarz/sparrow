require File.dirname(__FILE__) + '/key_normalizer'

module CamelCaser
  module Strategies
    class CamelizeKey
      include KeyNormalizer

      attr_accessor :strategy

      def initialize(strategy = :lower)
        self.strategy = strategy
      end

      def transform_key(key)
        # dont touch all_Upper Keys (like "DE")
        if key.upcase == key
          normalize_key(key)
        else
          normalize_key(key).camelize(strategy)
        end
      end
    end
  end
end
