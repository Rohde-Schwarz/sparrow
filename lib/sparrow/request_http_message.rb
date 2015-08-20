module Sparrow
  class RequestHttpMessage < HttpMessage
    def headers_hash
      env
    end

    ##
    # The HTTP Content Type Field
    # @return String
    def content_type
      request.content_type || http_header(:content_type)
    end
  end
end