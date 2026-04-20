# frozen_string_literal: true

require 'chefspec'

# This cookbook's specs use SoloRunner only, so Chef Zero is unnecessary and
# can be disabled to avoid binding a local listener in constrained environments.
ChefSpec::ZeroServer.singleton_class.class_eval do
  define_method(:setup!) { true }
  define_method(:reset!) { true }
  define_method(:teardown!) { true }
end

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.log_level = :error
end
