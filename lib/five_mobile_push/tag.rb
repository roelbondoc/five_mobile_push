module FiveMobilePush
  class Tag

    attr_accessor :device_uid

    def initialize(client, device_uid)
      @client = client
      self.device_uid = device_uid
    end
    
    def create(tags)
      @client.post 'device/tags/add', :id_type => 'native', :id_value => self.device_uid, :tags => tags.join(',')
    end

  end
end
