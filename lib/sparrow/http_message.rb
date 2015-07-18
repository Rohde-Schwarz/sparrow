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
      request.path || env['PATH_INFO']
    end

    def accept
      env['ACCEPT'] || env['Accept']
    end

    def content_type
      content_type = request.content_type ||
         env['CONTENT-TYPE'] ||
         env['Content-Type'] ||
         env['CONTENT_TYPE']
     content_type.to_s.split(';').first
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
  end
end
