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
        ret = @params || @env['rack.input'].send(:readlines).join
        @env['rack.input'].rewind
        ret
      end

      def self.handle(env, type)
        new(env, type).handle
      end

      def handle
        @env
      end

      def transform_params
        ensure_json
      end
    end
  end
end
