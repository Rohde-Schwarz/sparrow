module Sparrow
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
        super
        handle_form_hash
      end

      def params
        @params || env[Sparrow::Request::FORM_HASH_KEY]
      end

      private

      def handle_form_hash
        if params.present?
          transformed_params = transform_params
          @env[Sparrow::Request::FORM_HASH_KEY] = transformed_params
        end
      end
    end
  end
end
