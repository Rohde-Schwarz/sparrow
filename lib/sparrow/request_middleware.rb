require 'sparrow/middleware'

module Sparrow
  class RequestMiddleware < Middleware
    def convert(env)
      super
      strategy.handle(env, :request)
      env
    end

    def content_type
      my_content_type = request.content_type ||
          last_env['CONTENT-TYPE'] ||
          last_env['Content-Type'] ||
          last_env['CONTENT_TYPE']

      my_content_type.present? ? my_content_type : nil
    end

    def strategy
      if is_processable? && last_env[Strategies::FormHash::REQUEST_FORM_HASH_KEY]
        Rails.logger.debug 'Choosing strategy FormHash' if defined? Rails
        Strategies::FormHash
      else
        super
      end
    end
  end
end
