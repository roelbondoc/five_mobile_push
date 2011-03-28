require 'spec_helper'

describe FiveMobilePush::Device do

  let(:api_token) { 'token' }
  let(:application_uid) { 'nulayer' }
  let(:client) { FiveMobilePush::Client.new :api_token => api_token, :application_uid => application_uid }
  let(:device_uid) { '2b6f0cc904d137be2e1730235f5664094b831186' }
  let(:device_token) { 'ABCDEFG' }

  subject { FiveMobilePush::Device.new client, device_uid }

  describe '#register' do

    let(:register_endpoint) { device_endpoint('register') }

    context "registration data is provided" do

      it "registers a device with reg_data" do
        body = build_request_body(:device_id => device_uid, :reg_data => device_token)
        stub_request(:post, register_endpoint).with(:body => body)
        response = subject.register(device_token)
        a_request(:post, register_endpoint).with(:body => body).should have_been_made
      end

    end

    context "registration data is not provided" do

      it "registers a device" do
        body = build_request_body(:device_id => device_uid)
        stub_request(:post, register_endpoint).with(:body => body)
        response = subject.register
        a_request(:post, register_endpoint).with(:body => body).should have_been_made
      end

    end

  end

  context "id_value and id_type passed to service" do

    let(:body) { build_request_body(:id_type => 'native', :id_value => device_uid) }

    describe '#resume' do

      let(:resume_endpoint) { device_endpoint('resume') }

      it "resumes a device to receive push notifications" do
        stub_request(:post, resume_endpoint).with(:body => body)
        subject.resume
        a_request(:post, resume_endpoint).with(:body => body).should have_been_made
      end

    end

    describe '#suspend' do

      let(:suspend_endpoint) { device_endpoint('suspend') }

      it "suspends a device to not receive any push notifications" do
        stub_request(:post, suspend_endpoint).with(:body => body)
        subject.suspend
        a_request(:post, suspend_endpoint).with(:body => body).should have_been_made
      end

    end

    describe "#unregister" do

      let(:unregister_endpoint) { device_endpoint('unregister') }

      it "unregisters a device from receiving push notifications" do
        stub_request(:post, unregister_endpoint).with(:body => body)
        subject.unregister
        a_request(:post, unregister_endpoint).with(:body => body).should have_been_made
      end

    end

  end

  def device_endpoint(name)
    "https://push.fivemobile.com/rest/device/#{name}"
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

end
