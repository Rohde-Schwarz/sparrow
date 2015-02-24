require 'active_support/core_ext/string/starts_ends_with'
require 'camel_caser/path_normalizer'

module CamelCaser
  class RouteParser
    include PathNormalizer

    attr_accessor :excluded_routes

    def initialize(excluded_routes = CamelCaser.configuration.excluded_routes)
      self.excluded_routes = excluded_routes.map do |route|
        if route.is_a?(Regexp)
          route
        else
          Regexp.new(route.to_s)
        end
      end
    end

    def allow?(path)
      not exclude?(path)
    end

    def exclude?(path)
      normalized_path = normalize_path(path)
      excluded_routes.each do |route|
        return true if normalized_path =~ route
      end
      return false
    end
  end
end