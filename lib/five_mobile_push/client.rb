module FiveMobilePush
  class Client

    DEFAULT_ENDPOINT = 'https://push.fivemobile.com/rest/'

    attr_accessor :application_uid, :api_token

    def initialize(options={})
      self.application_uid = options[:application_uid] || FiveMobilePush.application_uid
      self.api_token = options[:api_token] || FiveMobilePush.api_token
    end


    def connection
      @connection ||= Faraday::Connection.new(:url => DEFAULT_ENDPOINT,
                                              :headers => { :accept =>  'application/json',
      :user_agent => 'FiveMobilePush Ruby gem'}) do |builder|
        builder.adapter Faraday.default_adapter
        builder.use Faraday::Response::ParseJson
        builder.use Faraday::Response::Mashify
      end
    end

    def get(path, options={})
      perform_request(:get, path, options)
    end

    def post(path, options={})
      perform_request(:post, path, options)
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
