module FiveMobilePush
  extend self

  VALID_OPTION_KEYS = [:api_token, :application_uid, :id_type]
  SUPPORTED_PLATFORMS = %w(iphone blackberry android)

  attr_accessor *VALID_OPTION_KEYS

  def configure
    yield self
  end

end
