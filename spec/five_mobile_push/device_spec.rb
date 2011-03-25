require 'spec_helper'

describe FiveMobilePush::Device do

  let(:client) { FiveMobilePush::Client.new :api_token => 'token', :application_uid => 'nulayer' }
  let(:device_uid) { '2b6f0cc904d137be2e1730235f5664094b831186' }
  let(:device_token) { 'ABCDEFG' }

  subject { FiveMobilePush::Device.new client, device_uid }

  describe '#register' do

    it "registers a device with Five Mobile Push" do
      stub_request(:post, "https://push.fivemobile.com/rest/device/register?api_token=token&application_id=nulayer").to_return( 
        :body => fixture("register.json")
      )
      response = subject.register
      response.active.should be_true
    end

  end
  
end