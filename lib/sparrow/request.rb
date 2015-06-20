module Sparrow
  class Request
    attr_reader :env,
                :request

    def initialize(env)
      @env = env
    end

    def request
      @request ||= request_class.new(env)
    end

    def path
      request.path || env['PATH_INFO']
    end

    def content_type
      request.content_type ||
         env['CONTENT-TYPE'] ||
         env['Content-Type'] ||
         env['CONTENT_TYPE']
    end

    def method_missing(method_name, *args)
      request.public_send(method_name, *args)
    end

    def request_class
      if defined?(Rails)
        ActionDispatch::Request
      else
        Rack::Request
      end
    end
  end
end
