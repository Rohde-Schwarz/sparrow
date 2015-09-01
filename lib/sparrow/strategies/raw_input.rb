module Sparrow
  module Strategies
    ##
    # Handles plain JSON input parameter conversion which is sent via
    # env['rack.input']
    class RawInput
      include Transformable

      # @return [Hash] the Rack environment
      # @see #initialize
      attr_reader :env
      # @return [Symbol] the HTTP message type
      # @see #initialize
      attr_reader :type

      ##
      # Do the transformation
      # @return [Hash] the converted JSON as a Hash representation
      def self.handle(env, type)
        self.new(env, type).handle
      end

      # Create a new RawInput Strategy
      # @param [Hash] env the Rack environment
      # @param [Symbol] type the HTTP message type. Must be either :request or
      #  :response
      # @param [Hash] params the HTTP message parameters to be transformed
      #   if not already present in the env
      def initialize(env, type = :request, params = nil)
        @env    = env || {}
        @params = params
        @type   = type
      end

      ##
      # Starts the conversion
      # @return [Hash] the converted Rack environment
      def handle
        super
        handle_raw_rack
      end

      ##
      # The parameters to be transformed
      # @return [Hash] the JSON parameters
      # @see #initialize
      def params
        if @params
          @params
        else
          input_io = @env[HttpMessage::RACK_INPUT_KEY]
          params   = input_io.send(:read)
          input_io.rewind
          params
        end
      end

      private

      def handle_raw_rack
        if params.present?
          new_raw_input        = json_body.force_encoding("BINARY")
          @env[HttpMessage::RACK_INPUT_KEY] = StringIO.new(new_raw_input)
          @env[HttpMessage::RACK_INPUT_KEY].rewind
          @env['CONTENT_LENGTH'] = new_raw_input.length
        end
      end
    end
  end
end
