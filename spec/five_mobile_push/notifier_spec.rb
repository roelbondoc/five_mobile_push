require 'spec_helper'
require 'uri'

describe FiveMobilePush::Notifier do

  let(:api_token) { 'token' }
  let(:application_uid) { 'nulayer' }
  let(:client) { FiveMobilePush::Client.new :api_token => api_token, :application_uid => application_uid }

  subject { FiveMobilePush::Notifier.new client }
  
  describe "#broadcast" do

    let(:broadcast_endpoint) { notifier_endpoint('broadcast') }

    let(:payload) do
      {
        :msg => {
          :type => "string",
          :value => "You sir are awesome"
        }
      }      
    end

    it "broadcasts a notification to one or more platforms of the application" do
      stub_request(:post, broadcast_endpoint)
      subject.broadcast :iphone, payload
      a_request(:post, broadcast_endpoint).should have_been_made
    end

  end
  

  def notifier_endpoint(name)
    "https://push.fivemobile.com/rest/notify/#{name}"
  end

end
