require 'spec_helper'

describe FiveMobilePush::Device do

  let(:client) { Fabricate.build(:client) }

  let(:device_token) { 'ABCDEFG' }

  subject { Fabricate.build(:device) }

  describe '#register' do

    let(:register_endpoint) { device_endpoint('register') }

    let(:device_info) {
      {
        :manufacturer => 'Apple',
        :model        => 'iPhone 4',
        :platform     => 'iPhone OS',
        :platform_ver => 'iOS 4.3'
      }
    }

    context "registration data is provided" do

      let(:body) { build_request_body(client, :device_id => subject.device_uid, :reg_data => device_token, :device_info => MultiJson.encode(device_info)) }
      
      before(:each) do
        stub_request(:post, register_endpoint).to_return(:body => load_fixture('register.json'))
      end

      it "registers a device" do
        subject.register(device_info, device_token)
        a_request(:post, register_endpoint).with(:body => /device_info=.*reg_data=#{device_token}/).should have_been_made
      end

      it "returns a token on success" do
        response = subject.register(device_info, device_token)
        response['data'].should == '52750B30FFBC7DE3B362'
      end

    end

    context "registration data is not provided" do

      it "registers a device" do
        body = build_request_body(client, :device_id => subject.device_uid, :device_info => device_info)
        stub_request(:post, register_endpoint)
        subject.register(device_info)

        a_request(:post, register_endpoint).with(:body => /reg_data/).should_not have_been_made
      end

    end

  end

  context "id_value and id_type passed to service" do

    let(:body) { build_request_body(client, :id_type => FiveMobilePush::DEFAULT_ID_TYPE, :id_value => subject.device_uid) }

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
    (FiveMobilePush::Client::DEFAULT_ENDPOINT + "/device/#{name}").to_s
  end

end
