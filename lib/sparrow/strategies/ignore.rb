module Sparrow
  module Strategies
    class Ignore
      include Transformable

      def initialize(env, type = :request, params = nil)
        @env    = env
        @params = params
        @type   = type
      end

      def params
        ret = @params || @env[rack_input_key].send(:read)
        @env[rack_input_key].rewind
        ret
      end

      def self.handle(env, type)
        new(env, type).handle
      end

      def handle
        # synchronize rack.input and form hash values
        input = @env[rack_input_key].gets

        begin
          @env[form_hash_key] = MultiJson.load(input)
        rescue MultiJson::ParseError
          # ignore
        ensure
          @env[rack_input_key].rewind
        end if input.present?

        @env
      end

      def json_body
        params
      end

      def transform_params
        ensure_json
      end
    end
  end
end
