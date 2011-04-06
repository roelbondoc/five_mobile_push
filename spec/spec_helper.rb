require 'five_mobile_push'
require 'rspec'
require 'webmock/rspec'
require 'yajl'
require 'uri'
require 'fabrication'

RSpec.configure do |config|
  config.mock_with :rspec
end

def load_fixture(name)
  File.read File.expand_path("../fixtures/#{name}", __FILE__)
end

def build_request_body(data)
  data = data.merge(:api_token => api_token, :application_id => application_uid)
  String.new.tap do |body|
    data.each do |key,value|
      body << "#{key}=#{value}"
      body << "&" unless key == :application_id
    end
  end
end

# URI escape
def escape(s)
  URI.escape(s).gsub(',', '%2C')
end
