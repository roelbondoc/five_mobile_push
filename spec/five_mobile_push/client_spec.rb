require 'spec_helper'

describe FiveMobilePush::Client do

  let(:application_uid) { 'nulayer' }
  let(:api_token) { 'token_123' }

  subject { FiveMobilePush::Client.new :api_token => api_token, :application_uid => application_uid }

  it "connects using the fivemobile endpoint" do
    connection = subject.send(:connection).build_url(nil).to_s
    endpoint = URI.parse(described_class::DEFAULT_ENDPOINT)
    connection.should == endpoint.to_s
  end    
  
  describe "#device" do
    
    it "initializes a Device" do
      subject.device('abc').should be_kind_of(FiveMobilePush::Device)
    end
    
  end  
  
  context "response code is 400" do
    
    let(:path) { "https://push.fivemobile.com/rest/some_endpoint?api_token=#{api_token}&application_id=#{application_uid}" }
    
    it "raises a GeneralError" do
      stub_request(:any, path).to_return(:body => "something broken", :status => 400)
      expect { subject.get(path) }.to raise_error(FiveMobilePush::GeneralError)
    end
    
  end
  
  context "response code is 401" do
    
    let(:path) { "https://push.fivemobile.com/rest/some_endpoint?api_token=#{api_token}&application_id=#{application_uid}" }
    
    it "raises a GeneralError" do
      stub_request(:any, path).to_return(:body => "something broken", :status => 401)
      expect { subject.get(path) }.to raise_error(FiveMobilePush::UnauthorizedError)
    end
    
  end
  
  context "response code is 500" do
    
    let(:path) { "https://push.fivemobile.com/rest/some_endpoint?api_token=#{api_token}&application_id=#{application_uid}" }
    
    it "raises a GeneralError" do
      stub_request(:any, path).to_return(:body => "something broken", :status => 500)
      expect { subject.get(path) }.to raise_error(FiveMobilePush::ServerError)
    end
    
  end

end
