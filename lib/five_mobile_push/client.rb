require 'faraday'

module FiveMobilePush
  class Client

    DEFAULT_ENDPOINT = 'https://push.fivemobile.com/rest'

    attr_accessor :application_uid, :api_token

    def initialize(options={})
      self.application_uid = options[:application_uid] || FiveMobilePush.application_uid
      self.api_token       = options[:api_token]       || FiveMobilePush.api_token
    end

    def get(path, options={})
      perform_request(:get, path, options)
    end

    def post(path, options={})
      perform_request(:post, path, options)
    end

    def device(device_uid, device_token=nil)
      FiveMobilePush::Device.new(self, device_uid, device_token)
    end

    def notifier
      FiveMobilePush::Notifier.new(self)
    end

    def tag(device_uid, device_token)
      FiveMobilePush::Tag.new(self, device_uid, device_token)
    end

    private

      def perform_request(method, path, options={})
        options.merge!(
          :api_token      => options[:api_token] || api_token,
          :application_id => application_uid
        )

        conn = Faraday.new(:url => DEFAULT_ENDPOINT)

        begin
          resp = conn.send(method) do |req|
            req.url path, options
          end

          resp.tap do |r|
            if r.status == 400
              raise InvalidTokenError  if r.body =~ /Invalid API token/i
              raise UnknownDeviceError if r.body =~ /Unknown device/i
            end
          end
        rescue Faraday::Error::TimeoutError => e
          raise TimeoutError, e.message
        end
      end
  end
end
