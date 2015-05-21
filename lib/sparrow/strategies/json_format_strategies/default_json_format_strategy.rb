require 'singleton'

module Sparrow
  module Strategies
    class DefaultJsonFormatStrategy
      include Singleton

      def match?(input)
        true
      end

      def convert(input)
        input.to_s
      end
    end
  end
end
