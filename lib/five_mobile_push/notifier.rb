module FiveMobilePush
  class Notifier

    def initialize(client)
      @client = client
    end

    def broadcast(platforms, &block)
      @client.post 'notify/broadcast',
        :platforms => build_platforms_string(platforms),
        :payload   => capture_payload(&block).to_json
    end

    def notify_devices(devices, &block)
      @client.post 'notify/toDevices',
        :id_type   => FiveMobilePush::DEFAULT_ID_TYPE,
        :id_values => devices.join(','),
        :payload   => capture_payload(&block).to_json
    end

    def notify_by_tags(platforms, tags, &block)
      @client.post 'notify/toTags',
        :platforms => build_platforms_string(platforms),
        :tags      => tags.join(','),
        :payload   => capture_payload(&block).to_json
    end

    private

    def capture_payload(&block)
      payload_proxy = PayloadProxy.new
      block.call(payload_proxy)
      payload_proxy.to_payload
    end

    def build_platforms_string(platforms)
      if platforms.kind_of?(Enumerable)
        platforms.join(',')
      else
        platforms.to_s
      end
    end

    class PayloadProxy
      def message(message)
        @message = message
      end

      def meta_data(meta_data)
        @meta_data = meta_data
      end

      def to_payload
        FiveMobilePush::Payload.new(@message, @meta_data)
      end
    end

  end
end
