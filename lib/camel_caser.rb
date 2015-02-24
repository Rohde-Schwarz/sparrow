require 'active_support/version'
require 'camel_caser/version'
require 'camel_caser/configuration'
require 'camel_caser/route_parser'
require 'camel_caser/request_middleware'
require 'camel_caser/response_middleware'
require 'camel_caser/strategies/json_format_strategies/rack_body'
require 'camel_caser/strategies/json_format_strategies/array_strategy'
require 'camel_caser/railtie' if defined?(Rails)

module CamelCaser
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
  end
end
