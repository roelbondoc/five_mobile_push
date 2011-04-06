module FiveMobilePush
  class Notifier
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
  end
end
