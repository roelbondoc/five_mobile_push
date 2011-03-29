module FiveMobilePush
  class Notifier

    def initialize(client)
      @client = client
    end

    def broadcast(platforms, payload)
      @client.post 'notify/broadcast', :platforms => self.class.build_platforms_string(platforms), :payload => MultiJson.encode(payload)
    end
    
    def notify_devices(devices, payload)
      @client.post 'notify/toDevices', :id_type => 'native', :id_values => devices.join(','), :payload => MultiJson.encode(payload)
    end

    def notify_by_tags(platforms, tags, payload)
      @client.post 'notify/toTags', 
        :platforms => self.class.build_platforms_string(platforms),
        :tags => tags.join(','),
        :payload => MultiJson.encode(payload)
    end

    class << self

      def build_platforms_string(platforms)      
        if platforms.kind_of?(Enumerable)
          platforms.join(',')
        else
          platforms.to_s
        end
      end

    end

  end
end
