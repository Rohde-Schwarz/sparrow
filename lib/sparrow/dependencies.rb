require 'active_support/core_ext/object'
require 'active_support/core_ext/string'
require 'active_support/version'

if ActiveSupport::VERSION::STRING.match(/3\.\d+\.\d+/)
  require 'sparrow/core_ext/hash'
  require 'active_support/core_ext/object/to_param'
  require 'active_support/core_ext/object/to_query'
end

require 'singleton'
