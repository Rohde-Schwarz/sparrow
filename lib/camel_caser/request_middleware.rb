require 'camel_caser/middleware'

module CamelCaser
  class RequestMiddleware < Middleware
    def convert(env)
      super
      strategy.handle(env, :request)
      env
    end
  end
end
