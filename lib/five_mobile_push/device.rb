module FiveMobilePush
  class Device

    VALID_OPTION_KEYS = [:alias, :email]

    attr_reader :device_uid

    # @param [FiveMobilePush::Client] client The Client to use to send this request
    #
    # @param [String] device_uid The ID of the device being registered.
    #   Maximum of 64 characters.
    def initialize(client, device_uid)
      @client     = client
      @device_uid = device_uid
    end

    # Registers a device for receiving push notifications from an application.
    # If the device is already registered, this call can update the existing
    # registration details.
    #
    # @param [String] registration_data Platform specific device registration
    #   data, e.g. iOS device token. Optional for some platforms
    #
    # @param [Hash] device_info Information about the device being registered
    #
    # @option device_info [String] :manufacturer The device manufacturer.
    #   E.g. Apple, HTC, Motorola, RIM. Maximum 64 characters.
    #
    # @option device_info [String] :model The model of the device. E.g. iPhone 4,
    #   Nexus One
    #
    # @option device_info [String] :platform The software platform. E.g. iOS, Android
    #
    # @option device_info [String] :platform_ver Software platform version.
    #
    # @return [Hash] Has unique device API key. Required for many other calls.
    def register(device_info, registration_data=nil)
      options = {
        :device_id   => @device_uid,
        :device_info => MultiJson.encode(device_info)
      }

      options[:reg_data] = registration_data unless registration_data.nil?
      response = @client.post 'device/register', options
      MultiJson.decode(response.body)
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
