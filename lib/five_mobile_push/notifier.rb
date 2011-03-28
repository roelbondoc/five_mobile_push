module FiveMobilePush
  class Notifier

    attr_accessor :client

    def initialize(client)
      self.client = client
    end

    def broadcast(platforms, payload)
      client.post 'notify/broadcast', :platforms => self.class.build_platforms_string(platforms), :payload => MultiJson.encode(payload).to_s
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
