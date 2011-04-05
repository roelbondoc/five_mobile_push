module FiveMobilePush
  class Payload
    attr_accessor :message, :meta_data

    def initialize(message, meta_data=nil)
      self.message   = message
      self.meta_data = meta_data
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
