module Sparrow
  class ResponseHttpMessage < HttpMessage
    ##
    # @return [Integer] the HTTP Response Code status
    #   0 if not set.
    attr_accessor :status

    ##
    # @return the HTTP response body
    attr_accessor :body

    ##
    # @return the HTTP header after the middleware was called
    attr_accessor :headers

    private

    def headers_hash
      headers
    end
  end
end