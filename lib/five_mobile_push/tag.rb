module FiveMobilePush
  class Tag

    attr_accessor :device_uid

    def initialize(client, device_uid)
      @client = client
      self.device_uid = device_uid
    end
    
    def create(*tags)
      @client.post(end_point(:add), :id_type => FiveMobilePush::DEFAULT_ID_TYPE, :id_value => self.device_uid, :tags => normalize_tags(tags))
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
