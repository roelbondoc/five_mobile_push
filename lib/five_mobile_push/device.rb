module FiveMobilePush
  class Device

    VALID_OPTION_KEYS = [:alias, :email]

    attr_reader :uid, :token

    # @param [FiveMobilePush::Client] client The Client to use to send this request
    #
    # @param [String] uid The ID of the device being registered.
    #   Maximum of 64 characters.
    def initialize(client, uid, token=nil)
      @client = client
      @uid    = uid
      @token  = token
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
    def register(info, registration_data=nil)
      options = {
        :device_id   => @uid,
        :device_info => MultiJson.encode(info)
      }

      options[:reg_data] = registration_data unless registration_data.nil?
      response = @client.post 'device/register', options
      
      if response.headers['content-type'] =~ /json/i
        MultiJson.decode(response.body)
      else
        response.body
      end
    end

    def resume
      client_operation 'device/resume'
    end

    def suspend
      client_operation 'device/suspend'
    end

    def unregister
      client_operation 'device/unregister'
    end

    private
    
      def client_operation(method)
        @client.post method,
          :id_type => FiveMobilePush::DEFAULT_ID_TYPE,
          :id_value => @uid,
          :api_token => token
      end

  end

end
