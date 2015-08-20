module Sparrow
  module Strategies
    ##
    # This strategy is called when the HTTP message shall +not+ be transformed,
    # i.e. ignored.
    # This is inspired by the NullObject-Pattern to be convenient.
    class Ignore
      include Transformable

      ##
      # Create a new IgnoreStrategy
      # @param [Hash] env the Rack environment
      # @param [Symbol] type HTTP message type. Must be either :request or
      #   :response
      # @param [Hash] params The HTTP message params if not given in the env
      def initialize(env, type = :request, params = nil)
        @env    = env
        @params = params
        @type   = type
      end

      ##
      # Although we are ignoring any kind of conversion we still need to read
      # the parameters from the environment to be convenient with all other
      # calls in the chains and architecture *sigh*
      # Checks env['rack.input']
      # @return [Hash] the params
      def params
        ret = @params || @env[HttpMessage::RACK_INPUT_KEY].send(:read)
        @env[HttpMessage::RACK_INPUT_KEY].rewind
        ret
      end

      def self.handle(env, type)
        new(env, type).handle
      end

      ##
      # handles the conversion, i.e. here "do nothing"
      # Which is not strictly true - at write the rack.input to the form hash
      # key for convenience reasons to enable further middlewares to work with
      # it
      # @return [Hash] the rack env
      def handle
        # synchronize rack.input and form hash values
        input = @env[HttpMessage::RACK_INPUT_KEY].gets

        begin
          @env[HttpMessage::FORM_HASH_KEY] = MultiJson.load(input)
        rescue MultiJson::ParseError
          # ignore
        ensure
          @env[HttpMessage::RACK_INPUT_KEY].rewind
        end if input.present?

        @env
      end

      ##
      # Alias for #params
      # @see #params
      def json_body
        params
      end

      ##
      # Transforms the params to a Ruby JSON Hash representation
      # @return [Hash] the JSON
      def transform_params
        ensure_json
      end
    end
  end
end
