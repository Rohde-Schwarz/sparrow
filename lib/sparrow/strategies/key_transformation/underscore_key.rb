module Sparrow
  module Strategies
    module KeyTransformation
      ##
      # Strategy class for snake_casing keys
      class UnderscoreKey
        ##
        # Create a new UnderscoreKey Strategy
        # Does nothing except returning a plain instance.
        def initialize(*args)
          # no initialization needed
        end

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
