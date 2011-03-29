module FiveMobilePush
  class Device

    VALID_OPTION_KEYS = [:alias, :email]

    attr_accessor :device_uid

    def initialize(client, device_uid, options={})
      @client = client
      self.device_uid = device_uid
    end

    # Registers a device for receiving push notifications from an application.
    # If the device is already registered, this call can update the existing registration details.
    #
    def register(registration_data=nil)
      options = {:device_id => self.device_uid}
      options[:reg_data] = registration_data unless registration_data.nil?
      @client.post 'device/register', options
    end

    def resume
      @client.post 'device/resume', :id_type => 'native', :id_value => self.device_uid
    end

    def suspend
      @client.post 'device/suspend', :id_type => 'native', :id_value => self.device_uid
    end

    def unregister
      @client.post 'device/unregister', :id_type => 'native', :id_value => self.device_uid
    end

  end

end
