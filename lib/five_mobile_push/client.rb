require 'uri'
require 'faraday'

module FiveMobilePush
  class Client

    DEFAULT_ENDPOINT = 'https://push.fivemobile.com/rest'

    attr_accessor :application_uid, :api_token

    def initialize(options={})
      self.application_uid = options[:application_uid] || FiveMobilePush.application_uid
      self.api_token = options[:api_token]             || FiveMobilePush.api_token
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
        options.merge!({:api_token      => options[:api_token] || self.api_token,
                        :application_id => self.application_uid })

        uri = [DEFAULT_ENDPOINT, path].join('/')

        # Pass through the request, :GET, :POST, etc.
        resp = Faraday.send(method, uri, options)
        
        # Basic error checking
        if resp.status == 400
          raise InvalidToken if resp.body =~ /Invalid API token/i
        end
        
        # Response
        resp
      end
  end
end
