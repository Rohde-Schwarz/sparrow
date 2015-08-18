module Sparrow
  ##
  # Parent middleware class for both Requests and Responses.
  # Provides common accessors, but does not modify the http message.
  class Middleware
    # @return [Object] the parent Rack application in the stack.
    attr_reader :app
    # @return [Array<String>] the rack body after the middleware call
    attr_reader :body
    # @return [Hash<String, String>] the HTTP Headers after the middleware call
    attr_reader :headers
    # @return [Integer] the HTTP status after the middleware call
    attr_reader :status
    # @return [Array<Integer>] List of ignored HTTP response codes
    # @see Configuration#ignored_response_codes
    attr_reader :ignored_response_codes


    ##
    # Creates a new Middleware object
    # @param [#call] app the Rack application as defined by. Any object that
    #   responds to #call as defined in {https://rack.github.io/}.
    # @param [Array<Integer>] ignored_response_codes List of HTTP Status codes
    #   that shall not be processed
    def initialize(app,
                   ignored_response_codes:
                       Sparrow.configuration.ignored_response_codes)
      @app                    = app
      @ignored_response_codes = ignored_response_codes
    end

    # @return [Array] The Rack tuple of status, headers and body
    # as defined by {https://rack.github.io/}
    # Does nothing by default.
    def call(env)
      @last_env                = env
      @status, @headers, @body = @app.call(convert(env))
    end

    # Converts the Rack environment
    # Does nothing.
    # @param [Hash] env the rack env
    # @return [Hash] the rack env
    def convert(env)
      env
    end

    private

    def steward
      Steward.new(http_message,
                  allowed_content_types: Sparrow.configuration.allowed_content_types,
                  allowed_accepts:       Sparrow.configuration.allowed_accepts,
                  excluded_routes:       Sparrow.configuration.excluded_routes)
    end

    def strategy
      strategy = if steward.has_processable_http_message?
                   Strategies::RawInput
                 else
                   Strategies::Ignore
                 end

      Sparrow.logger.debug("Choosing strategy #{strategy.name}")
      strategy
    end

    def last_env
      @last_env || {}
    end

    def http_message
      HttpMessage.new(last_env)
    end
  end
end
