module Sparrow
  ##
  # Parses the http_mesage and provides information if it should be
  # processed, i.e. if the content type or accept header is applicable
  #
  # @todo this class is requested to be removed by issue #7 in the feature and
  # its internal will be moved to its counterparts such as HttpMessage itself.
  # @version 0.0.16
  class Steward
    ##
    # @return [HttpMessage] the wrapped http message object to be checked
    attr_reader :http_message

    ##
    # @return [Array<String>]
    # @see Sparrow::Configuration#allowed_accepts
    attr_reader :allowed_accepts

    ##
    # @return [Array<String>]
    # @see Sparrow::Configuration#allowed_content_types
    attr_reader :allowed_content_types

    ##
    # @return [Array<String,Regexp>]
    # @see Sparrow::Configuration#excluded_routes
    attr_reader :excluded_routes

    ##
    # @return [Array<Integer>]
    # @see Configuration#ignored_response_codes
    attr_reader :ignored_response_codes

    # @return [RouteParser] the route parser for the #excluded_routes
    # @see RouteParser
    # @see #exluded_routes
    attr_reader :route_parser

    ##
    # Initialize the Steward with the HTTP message to check and the specific
    # check options.
    #
    # @param options [Hash]
    # @option options [HttpMessage] :http_message the message to be checked
    # @option options [Array<String>] :allowed_accepts ([]) List of HTTP Accept
    #   Header options
    # @option options [Array<String>] :allowed_content_types ([])
    #   List of HTTP Content Type Header options
    # @option options [Array<String,Regexp>] :excluded_routes ([]) List of routes
    #   (paths) to not process
    #   (see Sparrow::Configuration#excluded_routes)
    # @option options [Array<Integer>] ignored_response_codes ([])
    #   (see Sparrow::Configuration#ignored_response_codes)
    # @see RouteParser#excluded_routes
    # @see Configuration
    def initialize(http_message, options = {})
      @http_message           = http_message
      @allowed_accepts        = options.fetch(:allowed_accepts, [])
      @allowed_content_types  = options.fetch(:allowed_content_types, [])
      @excluded_routes        = options.fetch(:excluded_routes, [])
      @ignored_response_codes = options.fetch(:ignored_response_codes, [])
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

    ##
    # @private
    def includes_route?
      route_parser.allow?(http_message.path)
    end

    ##
    # @private
    def allowed_content_type?
      content_type = http_message.content_type
      content_type_equals?(content_type) || content_type_matches?(content_type)
    end

    ##
    # @private
    def allowed_accept_header?
      accept_header = http_message.accept

      allowed_accepts.include?(nil) ||
          accept_type_matches?(allowed_accepts, accept_header)
    end

    ##
    # @private
    def content_type_equals?(type)
      allowed_content_types.include?(type)
    end

    ##
    # @private
    def content_type_matches?(type)
      matches = allowed_content_types.map do |acceptable_content_type|
        (acceptable_content_type &&
            type.to_s.starts_with?(acceptable_content_type.to_s))
      end

      matches.any?
    end

    ##
    # @private
    def accept_type_matches?(accepted_headers, type)
      accepted_headers.detect do |accept|
        type.include?(accept)
      end
    end
  end
end
