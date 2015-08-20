module Sparrow
  class ResponseSteward < Steward
    def has_processable_http_message?
      super && processable_status?
    end

    private

    def processable_status?
      !http_message.in?(ignored_response_codes)
    end
  end
end