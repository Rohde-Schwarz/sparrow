module Sparrow
  class Logger
    attr_accessor :enabled
    alias_method :enabled?, :enabled

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
