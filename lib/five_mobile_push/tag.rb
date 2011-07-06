module FiveMobilePush
  class Tag

    attr_accessor :device_uid, :device_token

    def initialize(client, device_uid, device_token)
      @client = client
      self.device_uid = device_uid
      self.device_token = device_token
    end
    
    def create(*tags)
      @client.post end_point(:add),
        :id_type => FiveMobilePush::DEFAULT_ID_TYPE,
        :id_value => self.device_uid,
        :tags => normalize_tags(tags),
        :api_token => device_token
    end

    def delete(*tags)
      @client.post end_point(:delete),
        :id_type => FiveMobilePush::DEFAULT_ID_TYPE,
        :id_value => self.device_uid,
        :tags => normalize_tags(tags),
        :api_token => device_token
    end
    
    def get
      @client.get end_point(:get),
        :id_type => FiveMobilePush::DEFAULT_ID_TYPE,
        :id_value => self.device_uid
    end

    private

    def normalize_tags(tags)
      tags.flatten.join(",")
    end

    def end_point(action)
      "device/tags/#{action}"
    end

  end
end
