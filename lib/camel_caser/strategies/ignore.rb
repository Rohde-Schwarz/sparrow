module CamelCaser
  module Strategies
    class Ignore
      include Transformable

      def initialize(env, type = :request, params = nil)
        @env    = env
        @params = params
        @type   = type
      end

      def params
        ret = @params || @env['rack.input'].send(:read)
        @env['rack.input'].rewind
        ret
      end

      def self.handle(env, type)
        new(env, type).handle
      end

      def handle
        # synchronize rack.input and form hash values
        input = @env['rack.input'].gets

        begin
          @env['rack.request.form_hash'] = MultiJson.load(input)
        rescue MultiJson::ParseError
          # ignore
        ensure
          @env['rack.input'].rewind
        end if input.present?

        @env
      end

      def transform_params
        ensure_json
      end
    end
  end
end
