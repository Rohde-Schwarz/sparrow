require 'sparrow/middleware'

module Sparrow
  class RequestMiddleware < Middleware
    def convert(env)
      super
      strategy.handle(env, :request)
      env
    end
  end
end
