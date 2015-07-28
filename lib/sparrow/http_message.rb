module Sparrow
  class HttpMessage
    FORM_HASH_KEY = 'rack.request.form_hash'
    RACK_INPUT_KEY = 'rack.input'

    attr_reader :env,
                :request

    def initialize(env)
      @env = env
    end

    def request
      @request ||= request_class.new(env)
    end

    def form_hash?
      env[FORM_HASH_KEY].present?
    end

    def path
      request.path || http_header(:path_info)
    end

    def accept
      http_header(:accept)
    end

    def content_type
      request.content_type || http_header(:content_type)
    end

    def method_missing(method_name, *args)
      request.public_send(method_name, *args)
    end

    def request_class
      if defined?(Rails)
        ::ActionDispatch::Request
      else
        ::Rack::Request
      end
    end

    private
    def http_header(key)
      key = key.to_s
      header_key = [
          key,
          key.upcase,
          key.upcase.dasherize,
          key.humanize,
          key.dasherize,
          key.parameterize,
          key.underscore.split('_').map(&:humanize).join('-')
      ].detect { |k| env[k].present? }

      env[header_key].to_s.split(';').first
    end
  end
end
