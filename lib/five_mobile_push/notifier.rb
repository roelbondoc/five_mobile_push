module FiveMobilePush
  # @todo Validate provided platforms
  class Notifier
    # @param [FiveMobilePush::Client] client The Client object to use when
    #   sending notices
    def initialize(client)
      @client = client
    end

    # Broadcast a notification to one or more platforms of an application.
    #
    # @param [Array<String>, String] platforms Any of the supported platforms.
    #
    # @yield [message] Provides a mini-DSL for constructing the message to
    #   broadcast.
    #
    # @yieldparam [Message] message (see Message)
    #
    # @example Simple usage
    #   n = FiveMobilePush::Notifier.new(client)
    #   n.broadcast(FiveMobilePush::Platform::ALL) do |message|
    #     message.body "Downtime this weekend"
    #   end
    #
    # @see FiveMobilePush::Platform.supported_platforms
    def broadcast(platforms, &block)
      @client.post 'notify/broadcast',
        :platforms => Platform.new(platforms).build_list,
        :payload   => Message.dsl(&block).to_json
    end

    # Send a notification to any number of specified devices
    #
    # @param [Array<String>] devices A list of device ID values
    #
    # @yield [message] Provides a mini-DSL for constructing the message to
    #   broadcast.
    #
    # @yieldparam [Message] message (see Message)
    #
    # @example Simple usage
    #   n = FiveMobilePush::Notifier.new(client)
    #   n.notify_devices(['1234']) do |message|
    #     message.body "Downtime this weekend"
    #   end
    def notify_devices(devices, &block)
      @client.post 'notify/toDevices',
        :id_type   => FiveMobilePush::DEFAULT_ID_TYPE,
        :id_values => devices.join(','),
        :payload   => Message.dsl(&block).to_json
    end

    # Notifies any device registered with the provided tags.
    #
    # @param [Array<String>, String] platforms Any of the supported platforms.
    # @param [Array<String>] tags Any tag that is registered
    #
    # @yield [message] Provides a mini-DSL for constructing the message to
    #   broadcast.
    #
    # @yieldparam [Message] message (see Message)
    #
    # @example Simple usage
    #   n = FiveMobilePush::Notifier.new(client)
    #   n.notify_by_tags(FiveMobilePush::Platform::ALL, ['muffin', 'bacon']) do |message|
    #     message.body "Downtime this weekend"
    #   end
    #
    # @see FiveMobilePush::Platform.supported_platforms
    def notify_by_tags(platforms, tags, &block)
      @client.post 'notify/toTags',
        :platforms => Platform.new(platforms).build_list,
        :tags      => tags.join(','),
        :payload   => Message.dsl(&block).to_json
    end
  end
end
