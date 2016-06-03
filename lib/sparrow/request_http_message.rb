module Sparrow
  class RequestHttpMessage < HttpMessage
    ##
    # @return [Hash] The HTTP Headers
    def headers_hash
      env
    end

    ##
    # @return [String] the request's path
    def path
      request.path || super
    end

    ##
    # The HTTP Content Type Field
    # @return [String] the HTTP Content Type
    def content_type
      request.content_type.presence || super
    end
  end
end