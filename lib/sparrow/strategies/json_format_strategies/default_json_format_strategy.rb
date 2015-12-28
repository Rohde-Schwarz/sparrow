module Sparrow
  module Strategies
    ##
    # NullObject JSON Format Strategy
    # Does no direct conversion except casting the given object to a string
    class DefaultJsonFormatStrategy
      include Singleton

      ##
      # Matches always since this is the NullObjectStrategy and thus the
      # fallback.
      # @param [Object] input the JSON input
      # @return [Boolean] True
      def match?(_input)
        true
      end

      ##
      # @param [#to_s] input the JSON object
      # @return [String] the input as a String
      def convert(input)
        input.to_s
      end
    end
  end
end
