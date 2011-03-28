require 'spec_helper'
require 'uri'

describe FiveMobilePush::Notifier do

  let(:api_token) { 'token' }
  let(:application_uid) { 'nulayer' }
  let(:client) { FiveMobilePush::Client.new :api_token => api_token, :application_uid => application_uid }

  subject { FiveMobilePush::Notifier.new client }
  
  let(:payload) do
    {
      :msg => {
        :type => "string",
        :value => "You sir are awesome"
      }
    }      
  end
  
  describe "#broadcast" do

    let(:broadcast_endpoint) { notifier_endpoint('broadcast') }

    it "broadcasts a notification to one or more platforms of the application" do
      stub_request(:post, broadcast_endpoint)
      subject.broadcast :iphone, payload
      a_request(:post, broadcast_endpoint).should have_been_made
    end

  end
  
  describe '#notify_devices' do
    
    let(:notify_devices_endpoint) { notifier_endpoint('toDevices') }
    
    it "notifies a list of devices" do
      stub_request(:post, notify_devices_endpoint)
      subject.notify_devices ['abc', 'def'], payload
      a_request(:post, notify_devices_endpoint).should have_been_made 
    end
    
  end

  def notifier_endpoint(name)
    "https://push.fivemobile.com/rest/notify/#{name}"
  end

end
