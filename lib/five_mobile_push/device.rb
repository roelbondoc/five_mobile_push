module FiveMobilePush
  class Device

    VALID_OPTION_KEYS = [:alias, :email]

    def initialize(client, device_uid)
      @client     = client
      @device_uid = device_uid
    end

    # Registers a device for receiving push notifications from an application.
    # If the device is already registered, this call can update the existing registration details.
    #
    def register(registration_data=nil)
      options = {:device_id => @device_uid}
      options[:reg_data] = registration_data unless registration_data.nil?
      @client.post 'device/register', options
    end

    def resume
      @client.post 'device/resume', :id_type => FiveMobilePush::DEFAULT_ID_TYPE, :id_value => @device_uid
    end

    def suspend
      @client.post 'device/suspend', :id_type => FiveMobilePush::DEFAULT_ID_TYPE, :id_value => @device_uid
    end

    def unregister
      @client.post 'device/unregister', :id_type => FiveMobilePush::DEFAULT_ID_TYPE, :id_value => @device_uid
    end

  end

end
