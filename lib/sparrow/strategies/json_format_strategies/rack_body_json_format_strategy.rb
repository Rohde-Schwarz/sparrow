module Sparrow
  module Strategies
    class RackBodyJsonFormatStrategy < JsonFormatStrategy
      register_json_format

      ##
      # Checks if the input is a RackBody
      # @param [#body] input the possible JSON input object
      # @return [Boolean] True if the given input responds to #body
      def match?(input)
        input.respond_to?(:body)
      end

      ##
      # @param [#body] input the JSON input object
      # @return [String] the input body
      def convert(input)
        input.body
      end
    end
  end
end
