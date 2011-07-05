require 'spec_helper'

describe FiveMobilePush::Client do

  let(:application_uid) { 'nulayer' }
  let(:api_token) { 'token_123' }

  subject { FiveMobilePush::Client.new :api_token => api_token, :application_uid => application_uid }

  it "connects using the fivemobile endpoint" do
    connection = subject.send(:connection).build_url(nil).to_s
    connection.should == described_class.default_endpoint.to_s
  end    
  
  describe "#device" do
    
    it "initializes a Device" do
      subject.device('abc').should be_kind_of(FiveMobilePush::Device)
    end
    
  end  
  
  describe "#notifier" do
    
    it "initializes a Notifier" do
      subject.notifier.should be_kind_of(FiveMobilePush::Notifier)
    end

  end

  describe "#tag" do

    it "initializes a Tag" do
      subject.tag('device-uid').should be_kind_of(FiveMobilePush::Tag)
    end

  end
  
  context "response code is 400" do
    
    let(:path) { (described_class.default_endpoint + "some_endpoint?api_token=#{api_token}&application_id=#{application_uid}").to_s }
    
    it "raises a GeneralError" do
      stub_request(:any, path).to_return(:body => "something broken", :status => 400)
      expect { subject.get(path) }.to raise_error(FiveMobilePush::GeneralError)
    end
    
  end
  
  context "response code is 401" do
    
    let(:path) { (described_class.default_endpoint + "some_endpoint?api_token=#{api_token}&application_id=#{application_uid}").to_s }
    
    it "raises a GeneralError" do
      stub_request(:any, path).to_return(:body => "something broken", :status => 401)
      expect { subject.get(path) }.to raise_error(FiveMobilePush::UnauthorizedError)
    end
    
  end
  
  context "response code is 500" do
    
    let(:path) { (described_class.default_endpoint + "some_endpoint?api_token=#{api_token}&application_id=#{application_uid}").to_s }
    
    it "raises a GeneralError" do
      stub_request(:any, path).to_return(:body => "something broken", :status => 500)
      expect { subject.get(path) }.to raise_error(FiveMobilePush::ServerError)
    end
    
  end

  describe '.default_endpoint' do
    it { described_class.default_endpoint.should be_a(URI) }

    it 'acts as a URI object' do
      uri = described_class.default_endpoint + 'foo'
      uri.to_s.should =~ /foo\z/
    end
  end
end
