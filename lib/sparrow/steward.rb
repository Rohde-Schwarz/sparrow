module Sparrow
  ##
  # Parses the http_mesage and provides information if it should be
  # processed, i.e. if the content type or accept header is applicable
  #
  # @deprecated this class is requested to be removed in the feature and its
  # internal will be moved to its counterparts such as HttpMessage itself.
  class Steward
    ##
    # @return (see Sparrow::Configuration#allowed_accepts)
    attr_reader :allowed_accepts
    ##
    # @return (see Sparrow::Configuration#allowed_content_types)
    attr_reader :allowed_content_types
    ##
    # @return (see Sparrow::Configuration#excluded_routes)
    attr_reader :excluded_routes
    ##
    # @return (see Sparrow::Configuration#ignored_response_codes)
    attr_reader :ignored_response_codes
    ##
    # @return [HttpMessage] the wrapped http message object to be checked
    attr_reader :http_message

    # see (Sparrow::RouteParser) for the #excluded_routes
    attr_reader :route_parser

    ##
    # Initialize the Steward by the http_message to check and the specific
    # options against +which+ to check
    #
    # @param [HttpMessage] http_message the message to be checked
    # @param [Array<String>] allowed_accepts List of HTTP Accept Header options
    # @param [Array<String>] allowed_content_types List of HTTP Content Type
    #   Header options
    # @param [Array<String,Regexp>] excluded_routes List of routes (paths) to
    #   not process
    #  (see Sparrow::Configuration#excluded_routes)
    # @param [Array<Integer>] ignored_response_codes
    #   (see Sparrow::Configuration#ignored_response_codes)
    # @see RouteParser#excluded_routes
    # @see Configuration
    def initialize(http_message,
                   allowed_accepts: [],
                   allowed_content_types: [],
                   excluded_routes: [],
                   ignored_response_codes: [])
      @http_message           = http_message
      @allowed_accepts        = allowed_accepts
      @allowed_content_types  = allowed_content_types
      @excluded_routes        = excluded_routes
      @ignored_response_codes = ignored_response_codes
      @route_parser           = RouteParser.new(excluded_routes)
    end

    ##
    # Checks the +http_message+ against any given criteria specified by the
    # +options+ within the constructor
    #
    # @return [Boolean] processable message
    def has_processable_http_message?
      includes_route? &&
          allowed_content_type? &&
          allowed_accept_header?
    end

    private

    def includes_route?
      route_parser.allow?(http_message.path)
    end

    def allowed_content_type?
      content_type = http_message.content_type
      content_type_equals?(content_type) || content_type_matches?(content_type)
    end

    def allowed_accept_header?
      accept_header = http_message.accept

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
