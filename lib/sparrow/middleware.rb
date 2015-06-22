module Sparrow
  class Middleware
    attr_reader :app,
                :body,
                :headers,
                :status

    def initialize(app)
      @app = app
    end

    def call(env)
      @last_env                = env
      @status, @headers, @body = @app.call(convert(env))
    end

    def convert(env)
      env
    end

    private

    def steward
      Steward.new(request,
        allowed_content_types: Sparrow.configuration.allowed_content_types,
        allowed_accepts:       Sparrow.configuration.allowed_accepts,
        excluded_routes:       Sparrow.configuration.excluded_routes,
        content_type:          content_type)
    end

    def strategy
      strategy = if steward.has_processable_request?
                   Strategies::RawInput
                 else
                   Strategies::Ignore
                 end

      Sparrow.logger.debug("Choosing strategy #{strategy.class.name}")
      strategy
    end

    def last_env
      @last_env || {}
    end

    def request
      Request.new(last_env)
    end
  end
end
