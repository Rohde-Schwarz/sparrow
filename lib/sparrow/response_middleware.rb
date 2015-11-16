module Sparrow
  ##
  # Handles the Response conversion
  class ResponseMiddleware < Middleware
    ##
    # This call ends the rack chain
    # @param [Hash] env the Rack environment
    # @return [Array<String, Hash, Array<String>>] the Rack return Array
    def call(env)
      @last_env                = env
      @status, @headers, @body = app.call(env)
      [status, headers, converted_response_body]
    end

    private

    def steward
      configuration = Sparrow.configuration
      ResponseSteward.new(http_message,
                          allowed_content_types:  configuration.allowed_content_types,
                          allowed_accepts:        configuration.allowed_accepts,
                          excluded_routes:        configuration.excluded_routes,
                          ignored_response_codes: configuration.ignored_response_codes)
    end

    def converted_response_body
      # return the original body if we are not going to process it
      return body unless steward.has_processable_http_message?

      response_body = Sparrow::Strategies::JsonFormatStrategy.convert(body)

      return [] if response_body.blank?

      @headers.delete 'Content-Length'
      response_strategy = strategy.new(last_env, :response, response_body)
      response_strategy.handle
      Array(response_strategy.json_body)
    end

    def http_message
      response_message         = ResponseHttpMessage.new(last_env)
      response_message.status  = status
      response_message.body    = body
      response_message.headers = headers
      response_message
    end
  end
end
