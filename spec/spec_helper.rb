require "bundler/setup"
require_relative "../lib/monopoke"
require "rspec/version"

require "pry"

# From: https://stackoverflow.com/questions/1480537/how-can-i-validate-exits-and-aborts-in-rspec
RSpec::Matchers.define :exit_with_code do |exp_code|
  actual = nil
  match do |block|
    begin
      block.call
    rescue SystemExit => e
      actual = e.status
    end
    actual and actual == exp_code
  end
  failure_message do |block|
    "expected block to call exit(#{exp_code}) but exit" +
        (actual.nil? ? " not called" : "(#{actual}) was called")
  end
  failure_message_when_negated do |block|
    "expected block not to call exit(#{exp_code})"
  end
  description do
    "expect block to call exit(#{exp_code})"
  end
  supports_block_expectations
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  # config.order = :random
  # Kernel.srand config.seed

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
