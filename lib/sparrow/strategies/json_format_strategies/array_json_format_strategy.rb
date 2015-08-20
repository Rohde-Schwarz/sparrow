module Sparrow
  module Strategies
    class ArrayJsonFormatStrategy < JsonFormatStrategy
      register_json_format

      ##
      # Matches if input is an Array
      # @param [Object] input the JSON object
      # @return true if the input is an Array
      def match?(input)
        input.is_a? Array
      end

      ##
      # Takes the first element from the Array and returns it
      # @param [Array] the input Array
      # @return [String] the first element of the input as a String
      def convert(input)
        input.first.to_s
      end
    end
  end
end
