module Sparrow
  module Strategies
    module KeyTransformation
      ##
      # Strategy class for snake_casing keys
      class UnderscoreKey
        ##
        # Transforms the given key to snake_case format
        # @param [String] key the key to be transformed
        # @return [String] the snake_cased key
        def transform_key(key)
          key.to_s.underscore
        end
      end
    end
  end
end
