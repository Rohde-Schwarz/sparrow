module Sparrow
  ##
  # Handles the Response conversion
  class ResponseMiddleware < Middleware
    ##
    # This call ends the rack chain
    # @param [Hash] env the Rack environment
    # @return [Array<Object>] the Rack return Array
    def call(env)
      @last_env                = env
      @status, @headers, @body = app.call(env)
      [status, headers, converted_response_body]
    end

    private

    def steward
      ResponseSteward.new(http_message,
                          allowed_content_types:  Sparrow.configuration.allowed_content_types,
                          allowed_accepts:        Sparrow.configuration.allowed_accepts,
                          excluded_routes:        Sparrow.configuration.excluded_routes,
                          ignored_response_codes: Sparrow.configuration.ignored_response_codes)
    end


    def converted_response_body
      return body unless steward.has_processable_http_message?

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

    def http_message
      response_message         = ResponseHttpMessage.new(last_env)
      response_message.status  = status
      response_message.body    = body
      response_message.headers = headers
      response_message
    end
  end
end
