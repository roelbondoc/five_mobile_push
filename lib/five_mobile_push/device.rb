module FiveMobilePush
  class Device

    VALID_OPTION_KEYS = [:alias, :email, :reg_data]

    attr_accessor :client, :device_uid

    def initialize(client, device_uid, options={})
      self.client = client
      self.device_uid = device_uid
    end

    # Registers a device for receiving push notifications from an application.
    # If the device is already registered, this call can update the existing registration details.
    #
    def register
      response = @client.connection.post do |request|
        request.url 'device/register'
      end
      response.body
    end

  end

end