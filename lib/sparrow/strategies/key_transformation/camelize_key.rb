module Sparrow
  module Strategies
    module KeyTransformation
      ##
      # Strategy class for converting JSON to a camelized format.
      # Meaning snake_case => snakeCase
      class CamelizeKey
        # @return [Symbol] the camelizing strategy
        # @see #initialize
        attr_accessor :strategy

        # @return [Boolean] Defines wether complete uppercased keys will be
        #   transformed
        # @see #initialize
        attr_accessor :camelize_ignore_uppercase_keys

        ##
        # Initialize a new CamelizeKey strategy
        # @param [Hash] options
        #  +strategy+ defines the camelizing strategy type.
        #  Defines how to camelize, which comes down to starting with a
        #  lowercased character or with an
        #  uppercased character. Thus possible values are :lower and :upper
        #
        #  +camelize_ignore_uppercase_keys+ Defines if already completely
        #  uppercased keys should not be transformed. I.e. JSON stays JSON if
        #  this is set to true. If it is set to false JSON will be transformed
        #  to Json.
        def initialize(options = {})
          self.strategy                       = options.fetch(:strategy, :lower)
          self.camelize_ignore_uppercase_keys =
              options.fetch(:camelize_ignore_uppercase_keys, true)
        end

        ##
        # Transform the given key to camelCase based on the configuration
        # options set on initialization.
        # @see #initialize
        # @param [String, #to_s] key the key value to be transformed
        # @return [String] the transformed key
        def transform_key(key)
          key = key.to_s
          if camelize_ignore_uppercase_keys && key.upcase == key
            key
          else
            key.camelize(strategy)
          end
        end
      end
    end
  end
end
