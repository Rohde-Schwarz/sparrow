module Sparrow
  module Strategies
    ##
    # Handles Form Hash transformations, i.e. HTTP messages that contain form
    # data
    class FormHash
      include Transformable

      # @return [Hash] the Rack environment
      # @see #initialize
      attr_reader :env
      # @return [Symbol] the HTTP message type. Either :request, or :response
      # @see #initialize
      attr_reader :type

      ##
      # Shortcut for handling a HTTP Message with this strategy.
      def self.handle(env, type)
        self.new(env, type).handle
      end

      # Create a new FormHash Strategy
      # @param [Hash] env the Rack environment
      # @param [Symbol] type the HTTP message type. Must be either :request or
      #  :response
      # @param [Hash] params the HTTP message parameters to be transformed
      #   if not already present in the env
      def initialize(env, type = :request, params = nil)
        @env    = env
        @params = params
        @type   = type
      end

      ##
      # Do the transformation
      # @return [Hash] the converted JSON as a Hash representation
      def handle
        super
        handle_form_hash
      end

      ##
      # If given in the constructor, this simply returns the given params
      # argument. Otherwise it will look in the #env for form hash data params
      # @return  [Hash] the HTTP message params
      # @see #initialize
      def params
        @params || env[HttpMessage::FORM_HASH_KEY]
      end

      private

      def handle_form_hash
        env[HttpMessage::FORM_HASH_KEY] = transform_params if params.present?
      end
    end
  end
end
