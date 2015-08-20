module Sparrow
  class RequestMiddleware < Middleware
    def convert(env)
      super
      strategy.handle(env, :request)
      env
    end

    def content_type
      http_message.content_type.presence
    end

    def strategy
      if steward.has_processable_http_message? &&
          http_message.form_hash?
        Sparrow.logger.debug 'Choosing strategy FormHash'
        Strategies::FormHash
      else
        super
      end
    end

    def http_message
      RequestHttpMessage.new(last_env)
    end
  end
end
