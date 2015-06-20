module Sparrow
  # Shall requests/responses be processed?
  class Steward
    attr_reader :allowed_accepts,
                :allowed_content_types,
                :content_type,
                :env,
                :excluded_routes

    def initialize(env, options = {})
      @env                   = env
      @allowed_accepts       = options.fetch(:allowed_accepts, [])
      @allowed_content_types = options.fetch(:allowed_content_types, [])
      @excluded_routes       = options.fetch(:excluded_routes, [])
      @content_type          = options.fetch(:content_type, '')
    end

    def has_processable_request?
      allowed_content_type? &&
        allowed_accept_header? &&
          includes_route?
    end

    private

    def request
      request_class = if defined?(Rails) then
                        ActionDispatch::Request
                      else
                        Rack::Request
                      end

      @request ||= request_class.new(env)
    end

    def includes_route?
      path = request.path || env['PATH_INFO']
      RouteParser.new(excluded_routes).allow?(path)
    end

    def allowed_content_type?
      content_type_equals?(content_type) || content_type_matches?(content_type)
    end

    def allowed_accept_header?
      accept_header = env['ACCEPT'] || env['Accept']

      allowed_accepts.include?(nil) ||
        accept_type_matches?(allowed_accepts, accept_header)
    end

    def content_type_equals?(type)
      allowed_content_types.include?(type)
    end

    def content_type_matches?(type)
      matches = allowed_content_types.map do |acceptable_content_type|
        (acceptable_content_type &&
          type.to_s.starts_with?(acceptable_content_type.to_s))
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
