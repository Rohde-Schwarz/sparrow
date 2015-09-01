
module Sparrow
  class ResponseMiddleware < Middleware
    def call(env)
      @last_env                = env
      @status, @headers, @body = @app.call(env)
      [status, headers, converted_response_body]
    end

    def converted_response_body
      # return the original body if we are not going to process it
      return body if unprocessable_status?
      return body unless strategy.has_processable_request?

      response_body = Sparrow::Strategies::JsonFormatStrategy.convert(body)

      return [] unless response_body.present?

      @headers.delete 'Content-Length'
      response_strategy = strategy.new(last_env, :response, response_body)
      response_strategy.handle
      Array(response_strategy.json_body)
    end

    def unprocessable_status?
      @status.in?(500..511) || @status == 404
    end

    def content_type
      headers['Content-Type'].split(';').first # ||
          # last_env['CONTENT-TYPE'] ||
          # last_env['Content-Type'] ||
          # last_env['CONTENT_TYPE']
    end
  end
end
