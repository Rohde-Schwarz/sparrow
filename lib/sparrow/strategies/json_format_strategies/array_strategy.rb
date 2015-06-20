module Sparrow
  module Strategies
    class ArrayStrategy < JsonFormatStrategy
      register_json_format

      def match?(input)
        input.is_a? Array
      end

      def convert(input)
        input.first
      end
    end
  end
end
