require 'active_support/core_ext/object/blank'
require 'camel_caser/middleware'
require 'camel_caser/strategies/json_format_strategies/json_format_strategy'

module CamelCaser
  class ResponseMiddleware < Middleware
    def call(env)
      @last_env                = env
      @status, @headers, @body = @app.call(env)
      [status, headers, converted_response_body]
    end

    def converted_response_body
      response_body = CamelCaser::Strategies::JsonFormatStrategy.convert(body)

      # just pass the response if something went wrong inside the application
      return response_body if unprocessable_status?

      if response_body.present?
        response_strategy = strategy.new(last_env, :response, response_body)
        response_strategy.handle

        if response_body.is_a?(Array) then
          response_body
        else
          Array(response_strategy.json_body)
        end
      else
        []
      end
    end

    def unprocessable_status?
      @status.in?(500..599) || @status == 404
    end
  end
end
