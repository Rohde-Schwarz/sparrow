require 'active_support/core_ext/object'
require 'active_support/core_ext/string'
require 'active_support/version'

module Sparrow
  module_function

  def uses_active_support_legacy_version?
    active_support_legacy_version = /3\.\d+\.\d+/
    ActiveSupport::VERSION::STRING.match(active_support_legacy_version)
  end
end

if Sparrow.uses_active_support_legacy_version?
  require 'sparrow/core_ext/hash'
  require 'active_support/core_ext/object/to_param'
  require 'active_support/core_ext/object/to_query'
end

unless defined?(Rails)
  require 'active_support/core_ext/logger'
end

require 'singleton'
