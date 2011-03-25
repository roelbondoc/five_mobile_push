module FiveMobilePush
  class Client

    DEFAULT_ENDPOINT = 'https://push.fivemobile.com/rest/'

    attr_accessor :application_uid, :api_token, :api_endpoint

    def initialize(options={})
      self.api_endpoint = DEFAULT_ENDPOINT
      self.application_uid = options[:application_uid] || FiveMobilePush.application_uid
      self.api_token = options[:api_token] || FiveMobilePush.api_token
    end


    def connection
      @connection ||= Faraday::Connection.new(:url => self.api_endpoint,
                                              :params => {:api_token => self.api_token, :application_id =>  self.application_uid },
                                              :headers => { :accept =>  'application/json',
      :user_agent => 'FiveMobilePush Ruby gem'}) do |builder|
        builder.adapter Faraday.default_adapter
        builder.use Faraday::Response::MultiJson
        builder.use Faraday::Response::Mashify
      end

    end
  end
end
