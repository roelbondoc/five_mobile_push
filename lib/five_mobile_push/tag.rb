module FiveMobilePush
  class Tag

    attr_accessor :client, :device_uid

    def initialize(client, device_uid)
      self.client = client
      self.device_uid = device_uid
    end
    
    def create(tags)
      self.client.post 'device/tags/add', :id_type => 'native', :id_value => self.device_uid, :tags => tags.join(',')
    end

  end
end
