require File.dirname(__FILE__) + '/key_normalizer'

module CamelCaser
  module Strategies
    class UnderscoreKey
      include KeyNormalizer

      def transform_key(key)
        normalize_key(key).underscore
      end
    end
  end
end