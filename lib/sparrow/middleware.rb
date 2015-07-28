module Sparrow
  class Middleware
    attr_reader :app,
                :body,
                :headers,
                :status,
                :ignored_response_codes

    def initialize(app)
      @app                    = app
      @ignored_response_codes = Sparrow.configuration.ignored_response_codes
    end

    def call(env)
      @last_env = env
      @status, @headers, @body = @app.call(convert(env))
    end

    def convert(env)
      env
    end

    private

    def steward
      Steward.new(http_message,
                  allowed_content_types: Sparrow.configuration.allowed_content_types,
                  allowed_accepts: Sparrow.configuration.allowed_accepts,
                  excluded_routes: Sparrow.configuration.excluded_routes)
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
