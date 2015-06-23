module Sparrow
  module Strategies
    class FormHash
      include Transformable

      attr_reader :env,
                  :type

      def self.handle(env, type)
        self.new(env, type).handle
      end

      def initialize(env, type = :request, params = nil)
        @env    = env
        @params = params
        @type   = type
      end

      def handle
        super
        handle_form_hash
      end

      def params
        @params || env[form_hash_key]
      end

      private

      def handle_form_hash
        env[form_hash_key] = transform_params if params.present?
      end
    end
  end
end
