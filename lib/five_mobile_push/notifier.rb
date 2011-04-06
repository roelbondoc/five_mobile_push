module FiveMobilePush
  class Notifier

    def initialize(client)
      @client = client
    end

    def broadcast(platforms, &block)
      @client.post 'notify/broadcast',
        :platforms => build_platforms_string(platforms),
        :payload   => capture_message(&block).to_json
    end

    def notify_devices(devices, &block)
      @client.post 'notify/toDevices',
        :id_type   => FiveMobilePush::DEFAULT_ID_TYPE,
        :id_values => devices.join(','),
        :payload   => capture_message(&block).to_json
    end

    def notify_by_tags(platforms, tags, &block)
      @client.post 'notify/toTags',
        :platforms => build_platforms_string(platforms),
        :tags      => tags.join(','),
        :payload   => capture_message(&block).to_json
    end

    # Simple proxy class for building messages. Do not use this class directly.
    class Message
      # @param [String] body The text to send
      def body(body)
        @body = body
      end

      # @param [Hash] meta_data (optional) The optional meta data to send.
      def meta_data(meta_data)
        @meta_data = meta_data
      end

      # @private
      def to_payload
        FiveMobilePush::Payload.new(@message, @meta_data)
      end
    end

    private

    def capture_message(&block)
      payload_proxy = Message.new
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

  end
end
