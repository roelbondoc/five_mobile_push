module FiveMobilePush
  # @private Used internally. You'll never use this class directly.
  #   Documented for the benefit of contributors.
  class Payload
    MAXIMUM_MESSAGE_LENGTH = 128

    # This exception is raised when a payload meta data exceed its maximum length
    class MessageTooLargeError < ArgumentError
    end

    attr_reader :message, :meta_data

    # @param [#to_s] message The message you wish to send with a notice
    # @param [Hash] meta_data (nil) Any meta data to send along with the
    #   notice. Leave as +nil+ if none is to be sent.
    def initialize(message, meta_data={})
      self.message   = message
      self.meta_data = meta_data
    end

    def meta_data=(new_meta_data)
      validate_meta_data!(new_meta_data)
      @meta_data = new_meta_data
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

    def validate_meta_data!(meta_data)
      meta_data_is_correct_type!(meta_data)
      meta_data_messages_is_valid_length!(meta_data)
    end

    def meta_data_is_correct_type!(meta_data)
      unless meta_data.is_a?(Hash)
        raise ArgumentError, 'meta_data must be a Hash'
      end
    end

    # @todo Better error message for lengthy meta data
    def meta_data_messages_is_valid_length!(meta_data)
      unless meta_data.all? { |k, v| v.length <= MAXIMUM_MESSAGE_LENGTH }
        raise MessageTooLargeError
      end
    end

    def as_json
      {
        'msg' => {
          'type'  => 'string',
          'value' => message
        },
        'sound'  => 'default',
        'launch' => true
      }.merge(meta_data)
    end
  end
end
