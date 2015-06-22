module Sparrow
  class RequestMiddleware < Middleware
    def convert(env)
      super
      strategy.handle(env, :request)
      env
    end

    def content_type
      request.content_type.presence
    end

    def strategy
      if steward.has_processable_request? &&
          request.form_hash?
        Sparrow.logger.debug 'Choosing strategy FormHash'
        Strategies::FormHash
      else
        super
      end
    end
  end
end
