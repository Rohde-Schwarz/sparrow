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
      clazz = response_class
      @response ||= if clazz.name == 'ActionDispatch::Response'
                      clazz.new(status, headers_hash, body)
                    else
                      clazz.new(body, status, headers_hash)
                    end
    end

    def path
      super
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
      @headers_hash ||= env.merge(headers)
    end
  end
end