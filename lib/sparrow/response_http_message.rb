module Sparrow
  class ResponseHttpMessage < HttpMessage
    ##
    # @return [Integer] the HTTP Response Code status
    attr_accessor :status

    ##
    # @return the HTTP response body
    attr_accessor :body

    ##
    # @return the HTTP header after the middleware was called
    attr_accessor :headers

    ##
    # The wrapped Response instance
    # @return [Object] the response
    def response
      @response ||= response_class.new(status, body, headers)
    end

    def content_type
      response.content_type.presence || super
    end

    private

    def response_class
      if defined?(Rails)
        ActionDispatch::Response
      else
        ::Rack::Response
      end
    end

    def headers_hash
      headers
    end
  end
end