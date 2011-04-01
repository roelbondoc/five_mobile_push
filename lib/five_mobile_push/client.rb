require 'faraday/errors'

module FiveMobilePush
  class Client

    DEFAULT_ENDPOINT = 'https://push.fivemobile.com/rest/'

    attr_accessor :application_uid, :api_token, :adapter

    def initialize(options={})
      self.application_uid = options[:application_uid] || FiveMobilePush.application_uid
      self.api_token = options[:api_token]             || FiveMobilePush.api_token
      self.adapter = options[:adapter]                 || FiveMobilePush.adapter
    end


    def connection
      @connection ||= Faraday.new(:url => DEFAULT_ENDPOINT, :user_agent => 'FiveMobilePush Ruby gem') do |builder|
        builder.adapter self.adapter
        builder.use Faraday::Response::Errors
      end
    end

    def get(path, options={})
      perform_request(:get, path, options)
    end

    def post(path, options={})
      perform_request(:post, path, options)
    end

    def device(device_uid)
      FiveMobilePush::Device.new(self, device_uid)
    end

    def notifier
      FiveMobilePush::Notifier.new(self)
    end

    def tag(device_uid)
      FiveMobilePush::Tag.new(self, device_uid)
    end

    private

      def perform_request(method, path, options={})
        options.merge!({:api_token => self.api_token, :application_id =>  self.application_uid })
        connection.send(method) do |request|
          case method
          when :get, :delete
            request.url(path, options)
          when :post, :put
            request.path = path
            request.body = options
          end
        end
      end

  end
end
