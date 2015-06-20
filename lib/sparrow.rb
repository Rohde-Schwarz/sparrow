require 'sparrow/dependencies'
require 'sparrow/version'
require 'sparrow/configuration'
require 'sparrow/path_normalizer'
require 'sparrow/route_parser'
require 'sparrow/transformable'
require 'sparrow/strategies'
require 'sparrow/steward'
require 'sparrow/middleware'
require 'sparrow/request_middleware'
require 'sparrow/response_middleware'
require 'sparrow/logger'
require 'sparrow/railtie' if defined?(Rails)

module Sparrow
  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def reset_configuration
      @configuration = nil
    end

    def logger
      @logger ||= Logger.new(configuration.enable_logging)
    end
  end
end
