require 'multi_json'
require 'faraday'
require 'faraday_middleware'
require 'five_mobile_push/client'

module FiveMobilePush
  extend self
  
  autoload :Device, 'five_mobile_push/device'
  autoload :Notifier, 'five_mobile_push/notifier'
  autoload :Tag, 'five_mobile_push/tag'
  
  VALID_OPTION_KEYS = [:api_token, :application_uid]
  SUPPORTED_PLATFORMS = %w(iphone blackberry android)

  DEFAULT_ID_TYPE = 'native'

  attr_accessor *VALID_OPTION_KEYS

  def configure
    yield self
  end

end
