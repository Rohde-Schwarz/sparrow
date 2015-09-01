module Sparrow
  ##
  # Simple Logger class to handle behavior's in Rails and Rack environment
  # without the need to depend on an a "real" Logger to be available under the
  # hood.
  #
  # If the middleware is running in a Rails environment
  # (i.e. the Rails-constant is defined), is will delegate all its method calls
  # to the Rails logger.
  # Otherwise a simple log to STDOUT will get triggered using the method name as
  # log level and the argument as message.
  #
  # Examples:
  #
  #   Sparrow::Logger.debug('this is a debug message')
  #
  # when in a Rails env equals
  #
  #   Rails.logger.debug('this is a debug message')
  #
  # when not in a Rails environment the same call equals
  #
  #   ActiveSupport::Logger.debug("this is a debug message")
  class Logger
    ##
    # @return [Boolean] logging enabled
    attr_accessor :enabled
    alias_method :enabled?, :enabled

    ##
    # Wrapped Logger class
    # the Rails logger or a plain ActiveSupport::Logger instance using STDOUT
    attr_reader :logger

    # Initialize the Logger
    # Enables the logging only if +enabled+ is truthy.
    # Otherwise the logger will do nothing at all.
    #
    # @param [Boolean] enabled logging enabled
    def initialize(enabled)
      self.enabled = enabled
      @logger = if defined?(Rails) then
                  Rails.logger
                else
                  ::Logger.new(STDOUT)
                end
    end

    def method_missing(method_name, *args)
      logger.public_send(method_name, *args) if enabled?
    end
  end
end
