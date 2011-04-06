module FiveMobilePush
  class Payload
    attr_reader   :message
    attr_accessor :meta_data

    # @param [#to_s] message The message you wish to send with a notice
    # @param [Hash] meta_data (nil) Any meta data to send along with the
    #   notice. Leave as +nil+ if none is to be sent.
    def initialize(message, meta_data=nil)
      self.message   = message
      self.meta_data = meta_data
    end

    # @param [#to_s] message The message you wish to send with a notice
    def message=(message)
      @message = message.to_s
    end

    # @return [String] JSON representation of the Payload
    def to_json
      MultiJson.encode(as_json)
    end

    private

    def as_json
      payload = {
        'msg' => {
          'type'  => 'string',
          'value' => message
        },
        'sound'  => 'default',
        'launch' => true
      }
      payload['meta'] = meta_data if meta_data
      payload
    end
  end
end
