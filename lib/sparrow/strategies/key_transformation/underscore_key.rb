module Sparrow
  module Strategies
    module KeyTransformation
      class UnderscoreKey
        def transform_key(key)
          key.to_s.underscore
        end
      end
    end
  end
end
