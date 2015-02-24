require 'active_support/core_ext/object/blank'

module CamelCaser
  module Strategies
    class RawInput
      include Transformable

      attr_reader :env, :type

      def self.handle(env, type)
        self.new(env, type).handle
      end

      def initialize(env, type = :request, params = nil)
        @env    = env || {}
        @params = params
        @type   = type
      end

      def handle
        handle_raw_rack
      end

      def params
        if @params
          @params
        else
          input_io = @env['rack.input']
          params   = input_io.readlines.join
          input_io.rewind
          params
        end
      end

      private

      def handle_raw_rack
        if params.present?
          @env['rack.input'] = StringIO.new(json_body)
          @env['rack.input'].rewind
          @env['CONTENT_LENGTH'] = json_body.length
        end
      end
    end
  end
end
