require 'sparrow/strategies/json_format_strategies/default_json_format_strategy'
require 'active_support/core_ext/object/blank'

module Sparrow
  module Strategies
    class JsonFormatStrategy
      def initialize(*args)

      end

      def self.register_json_format(*args)
        init(args)
        @@json_format_strategies << self.new(args)
      end

      def self.convert(body)
        strategy = json_format_strategies.select do |strategy|
          strategy.match?(body)
        end.first
        strategy.convert(body)
      end

      private
      def self.init(*args)
        @@json_format_strategies ||= Array.new(args)
      end

      def self.json_format_strategies
        init
        default = Sparrow::Strategies::DefaultJsonFormatStrategy.instance
        @@json_format_strategies.reject(&:blank?) + [default]
      end
    end
  end
end
