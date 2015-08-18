module Sparrow
  ##
  # Simple Logger class to handle behavior's in Rails and Rack environment
  # without the need to depend on an a "real" Logger to be available under the
  # hood.
  #
  # If the middleware is running in a Rails environment
  # (i.e. the Rails-constant is defined), is will delegate all its method calls
  # to the Rails logger.
  # Otherwise a simply STDOUT puts will get triggered using the method name as
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
  #   puts "[debug] this is a debug message"
  class Logger
    # @return [Boolean] logging enabled
    attr_accessor :enabled
    alias_method :enabled?, :enabled

    # Initialize the Logger
    # Enables the logging only if +enabled+ is truthy.
    # Otherwise the logger will do nothing at all.
    #
    # @param [Boolean] enabled logging enabled
    def initialize(enabled)
      self.enabled = enabled
    end

    def method_missing(method_name, *args)
      if enabled?
        if defined?(Rails)
          Rails.logger.public_send(method_name, args)
        else
          puts "[#{method_name.upcase}] #{args}"
        end
      end
    end
  end
end
