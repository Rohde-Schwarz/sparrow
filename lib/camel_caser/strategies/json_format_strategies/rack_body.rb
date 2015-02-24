require File.dirname(__FILE__) + '/json_format_strategy'

module CamelCaser
  module Strategies
    class RackBody < JsonFormatStrategy
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