require 'active_support/core_ext/object/blank'
require 'camel_caser/strategies/form_hash'
require 'camel_caser/strategies/raw_input'
require 'camel_caser/strategies/ignore'

module CamelCaser
  class Middleware
    attr_reader :app, :body, :status, :headers

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

    def strategy
      if includes_route? && is_processable?
        if last_env['rack.request.form_hash'].present?
          Strategies::FormHash
        else
          Strategies::RawInput
        end
      else
        Strategies::Ignore
      end
    end

    def includes_route?
      path = request.path || last_env['PATH_INFO']
      RouteParser.new.allow?(path)
    end

    def is_processable?
      content_type = request.content_type || last_env['CONTENT-TYPE']
      content_type.in?(CamelCaser.configuration.accepted_content_types)
    end

    def last_env
      @last_env || {}
    end

    def request
      request_class = if defined?(Rails) then
                        ActionDispatch::Request
                      else
                        Rack::Request
                      end

      request_class.new(last_env)
    end
  end
end
