module Sparrow
  module Strategies
    class UnderscoreKey
      include KeyNormalizer

      def transform_key(key)
        normalize_key(key).underscore
      end
    end
  end
end
