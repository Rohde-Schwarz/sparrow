module CamelCaser
  module Strategies
    module KeyNormalizer
      def normalize_key(key)
        key.to_s
      end
    end
  end
end