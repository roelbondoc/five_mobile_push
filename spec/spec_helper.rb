require 'five_mobile_push'
require 'rspec'
require 'webmock/rspec'

RSpec.configure do |config|
  config.mock_with :rspec
end


def fixture(name)
  File.read File.expand_path("../fixtures/#{name}", __FILE__)
end