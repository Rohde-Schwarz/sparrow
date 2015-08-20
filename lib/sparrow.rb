require 'sparrow/dependencies'
require 'sparrow/version'
require 'sparrow/configuration'
require 'sparrow/route_parser'
require 'sparrow/transformable'
require 'sparrow/strategies'
require 'sparrow/http_message'
require 'sparrow/request_http_message'
require 'sparrow/response_http_message'
require 'sparrow/steward'
require 'sparrow/response_steward'
require 'sparrow/middleware'
require 'sparrow/request_middleware'
require 'sparrow/response_middleware'
require 'sparrow/logger'
require 'sparrow/railtie' if defined?(Rails)

module Sparrow
  class << self
    # Yields the configuration
    def configure
      yield configuration
    end

    # @return [Configuration] the configuration
    def configuration
      @configuration ||= Configuration.new
    end

    # resets the configuration values to their defaults, i.e.
    # reinitializes the Configuration object without any arguments
    # @return [Configuration] the (new initial) configuration
    def reset_configuration
      @configuration = Configuration.new
    end

    # @return [Logger] the middleware's logger
    def logger
      @logger ||= Logger.new(configuration.enable_logging)
    end
  end
end
