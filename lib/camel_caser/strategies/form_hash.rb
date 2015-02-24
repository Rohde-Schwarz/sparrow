require 'active_support/core_ext/object/blank'
require 'camel_caser/transformable'

module CamelCaser
  module Strategies
    class FormHash
      include Transformable

      attr_reader :env, :type

      def self.handle(env, type)
        self.new(env, type).handle
      end

      def initialize(env, type = :request, params = nil)
        @env    = env
        @params = params
        @type   = type
      end

      def handle
        handle_form_hash
      end

      def params
        @params || @env[form_hash_key]
      end

      private

      def handle_form_hash
        if params.present?
          @env[form_hash_key] = transform_params(params)
        end
      end

      def form_hash_key
        'rack.request.form_hash'
      end
    end
  end
end

