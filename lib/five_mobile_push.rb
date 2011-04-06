require 'multi_json'
require 'five_mobile_push/client'

module FiveMobilePush
  extend self

  autoload :Device,   'five_mobile_push/device'
  autoload :Notifier, 'five_mobile_push/notifier'
  autoload :Tag,      'five_mobile_push/tag'
  autoload :Payload,  'five_mobile_push/payload'
  autoload :Message,  'five_mobile_push/message'
  autoload :Platform, 'five_mobile_push/platform'

  class UnauthorizedError < StandardError; end
  class GeneralError      < StandardError; end
  class ServerError       < StandardError; end

  DEFAULT_ID_TYPE = 'native'

  attr_accessor :api_token, :application_uid

  attr_writer :adapter

  # @yield [config] Provides a block to conveniently configure the library
  #
  # @example Simple usage
  #
  #   FiveMobilePush.configure do |config|
  #     config.api_token       = '12345'
  #     config.application_uid = 'myfancyapp'
  #   end
  def configure
    yield self
  end

  def adapter
    @adapter || Faraday.default_adapter
  end

end
