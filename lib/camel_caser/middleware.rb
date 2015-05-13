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
      if is_processable?
        if last_env[Strategies::FormHash::REQUEST_FORM_HASH_KEY]
          Strategies::FormHash
        else
          Strategies::RawInput
        end
      else
        Strategies::Ignore
      end
    end

    def is_processable?
      accepted_content_type? && accepted_accept_header? && includes_route?
    end

    def includes_route?
      path = request.path || last_env['PATH_INFO']
      RouteParser.new.allow?(path)
    end

    def accepted_content_type?
      content_type_equals?(request_content_type) || content_type_matches?(request_content_type)
    end

    def accepted_accept_header?
      allowed_accepts = CamelCaser.configuration.allowed_accepts
      accept_header = last_env['ACCEPT'] || last_env['Accept']

      allowed_accepts.include?(nil) || accept_type_matches?(allowed_accepts, accept_header)
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

    def request_content_type
      content_type = request.content_type ||
          last_env['CONTENT-TYPE'] ||
          last_env['Content-Type'] ||
          last_env['CONTENT_TYPE']

      content_type.present? ? content_type : nil
    end

    def content_type_equals?(type)
      CamelCaser.configuration.allowed_content_types.include?(type)
    end

    def content_type_matches?(type)
      matches = CamelCaser.configuration.allowed_content_types.map do |acceptable_content_type|
        (acceptable_content_type && type.to_s.starts_with?(acceptable_content_type.to_s))
      end

      matches.any?
    end

    def accept_type_matches?(accepted_headers, type)
      accepted_headers.detect do |accept|
        type.include?(accept)
      end
    end
  end
end

