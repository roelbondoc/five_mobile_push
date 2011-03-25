require 'spec_helper'

describe FiveMobilePush::Client do

  let(:application_uid) { 'nulayer' }
  let(:api_token) { 'token_123' }

  subject { FiveMobilePush::Client.new :api_token => api_token, :application_uid => application_uid }

  it "connects using the fivemobile endpoint" do
    connection = subject.send(:connection).build_url(nil).to_s
    endpoint = URI.parse("#{subject.api_endpoint}?api_token=#{api_token}&application_id=#{application_uid}")
    connection.should == endpoint.to_s
  end

end
