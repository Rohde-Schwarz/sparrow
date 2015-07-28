module Sparrow
  class ResponseMiddleware < Middleware
    def call(env)
      @last_env = env
      @status, @headers, @body = app.call(env)
      [status, headers, converted_response_body]
    end

    def converted_response_body
      # return the original body if we are not going to process it
      return body if unprocessable_status?

      response_body = Sparrow::Strategies::JsonFormatStrategy.convert(body)

      if response_body.present?
        response_strategy = strategy.new(last_env, :response, response_body)
        response_strategy.handle

        if response_body.is_a?(Array)
          response_body
        else
          Array(response_strategy.json_body)
        end
      else
        []
      end
    end

    def unprocessable_status?
      @status.in?(ignored_response_codes)
    end
  end
end
