module Sparrow
  ##
  # Simple class the takes a list of routes and provides check methods
  # to determine if a path is excluded (ignored) or not, i.e.
  # the path is within the list as defined on initialization.
  class RouteParser
    attr_accessor :excluded_routes

    ##
    # Create a new Routeparser.
    # @param [Array<String, Regexp>] excluded_routes A list of routes (path)
    #   that shall not be parsed.
    #   Each route +must+ not start with a leading slash (/).
    def initialize(excluded_routes = Sparrow.configuration.excluded_routes)
      self.excluded_routes = excluded_routes.map do |route|
        if route.is_a?(Regexp)
          route
        else
          Regexp.new(route.to_s)
        end
      end
    end

    ##
    # States if the given path is +not+ within the excluded_routes
    #
    # @param [String] path the path to be checked
    # @return [Boolean] path allowed
    # @see #exclude?
    # @see #excluded_routes
    def allow?(path)
      !exclude?(path)
    end

    ##
    # States if the given path is within the excluded_routes, i.e. it may be
    # ignored when parsing.
    #
    # @param [String] path the path to be checked
    # @return [Boolean] is path excluded
    def exclude?(path)
      normalized_path = normalize_path(path)
      excluded_routes.each do |route|
        return true if normalized_path =~ route
      end
      return false
    end

    private
    def normalize_path(path)
      path[/./m] = '' if path.to_s.starts_with?('/')
      path
    end
  end
end
