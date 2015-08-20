module Sparrow
  module Strategies
    ##
    # Superclass for all JSON format strategies.
    # Contains no own instance logic, but keeps track of the registration
    # of all JSON format strategies with its Singleton class methods.
    class JsonFormatStrategy
      ##
      # Empty constructor
      def initialize(*args)
      end

      ##
      # Register a new JSON Format strategy
      # @param *args the arguments for the new strategy
      # @return [Array] the updated registered JSON Format strategies available
      def self.register_json_format(*args)
        init(args)
        @@json_format_strategies << self.new(args)
      end

      ##
      # Start a JSON conversion by its given string
      # @param [Object] a JSON object representation.
      #  can be any type a JSON format strategy is registered,
      #  i.e. an Array, a String or a RackBody
      # @return [String] the formatted JSON
      def self.convert(body)
        strategy = json_format_strategies.detect do |strategy|
          strategy.match?(body)
        end
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
