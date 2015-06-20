module Sparrow
  module Strategies
    class RackBodyJsonFormatStrategy < JsonFormatStrategy
      register_json_format

      def match?(input)
        input.respond_to?(:body)
      end

      def convert(input)
        input.body
      end
    end
  end
end
