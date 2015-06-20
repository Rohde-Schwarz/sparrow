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

      my_content_type.presence
    end

    def strategy
      if steward.has_processable_request? &&
          last_env[Strategies::FormHash::REQUEST_FORM_HASH_KEY]
        Sparrow.logger.debug 'Choosing strategy FormHash'
        Strategies::FormHash
      else
        super
      end
    end
  end
end
