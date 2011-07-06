require 'spec_helper'

FiveMobilePush.configure do |config|
  config.api_token        = '7ra6yke0qsgCnTRFPNiGMNJzMrWJW5NJ'
  config.application_uid  = 'NULAYER_SCOREDEV'
end

describe FiveMobilePush::Client do
  subject { described_class.new }

  let(:device) { double('Device', id: 12345, uid: 'abcdef') }

  let(:device_info) {
    {
      'manufacturer' => 'Apple',
      'model'        => 'iPhone 4',
      'platform'     => 'iPhone OS',
      'platform_ver' => '4.3.2'
    }
  }

  let(:reg_data) { 'cafebabe' }

  def register_device(device, args={})
    device_info.merge!(args)
    subject.device(device.uid).register(device_info, reg_data)
  end

  context 'device end points' do
    context 'valid device registration' do
      it 'registers the device device' do
        expect {
          register_device(device)
        }.to_not raise_error
      end

      it 'receives a device token' do
        response = register_device(device)
        response['data'].should_not be_nil
        response['type'].should == 'api_token'
      end
    end

    context 'attempt to register device with invalid info' do
      it 'invalid device manufacturer' do
        response = register_device(device, 'manufacturer' => 'jello')
        response.should include('data')
      end

      it 'invalid device model' do
        response = register_device(device, 'model' => '###F#F23f23f!@!@xyz')
        response.should include('data')
      end

      it 'invalid device platform' do
        response = register_device(device, 'platform' => 'xyz')
        response.should =~ /Unrecognized platform/
      end

      it 'invalid device platform_ver' do
        response = register_device(device, 'platform_ver' => '###F#F23f23f!@!@xyz')
        response.should include('data')
      end
    end

    it 'unregisters a subscription' do
      reg_response = register_device(device)
      device_token = reg_response['data']

      resp = subject.device(device.uid, device_token).unregister
      resp.status.should == 200
      resp.body.should == ''
    end

    it 'suspends a subscription' do
      reg_response = register_device(device)
      device_token = reg_response['data']

      resp = subject.device(device.uid, device_token).suspend
      resp.status.should == 200
      resp.body.should == ''
    end

    it 'suspends with an invalid token' do
      expect {
        subject.device(device.uid, 'wooohoo').suspend
      }.to raise_error(FiveMobilePush::InvalidToken)
    end

    it 'resumes a subscription' do
      reg_response = register_device(device)
      device_token = reg_response['data']

      resp = subject.device(device.uid, device_token).resume
      resp.status.should == 200
      resp.body.should == ''
    end
  end

  context 'notification end points' do
    let(:notifier) { subject.notifier }

    it "broadcasts a message to all platforms" do
      resp = notifier.broadcast(FiveMobilePush::Platform::ALL) do |message|
        message.body "Heyyo it's an rspec party"
      end

      resp.status.should == 200
    end

    it "send a message to a faulty device" do
      resp = notifier.notify_devices(['no-one']) do |message|
        message.body "No one should get this"
      end

      resp.status.should == 200
    end

    it "send a message to devices tagged" do
      resp = notifier.notify_by_tags(FiveMobilePush::Platform::ALL, ['mmmm', 'bacon']) do |message|
        message.body "eat your bacon"
      end

      resp.status.should == 200
    end
  end

  context "tag end points" do
    let(:tag1) { 'toronto' }

    let(:tag2) { 'summer' }

    let(:tags) { [tag1, tag2] }

    let!(:device_token) { register_device(device)['data'] }

    it "create a tag" do
      resp = subject.tag(device.uid, device_token).create(tags)
      resp.status.should == 200
    end

    it "delete a tag" do
      resp = subject.tag(device.uid, device_token).delete(tag2)
      resp.status.should == 200
    end

    # NOTE: I am pretty sure this does not work on FiveMobile's service...
    # resp.body keeps telling us the application_id must be supplied,
    # but we are passing it ..
    it "get a device's tags" do
      subject.tag(device.uid, device_token).create(tags)

      resp = subject.tag(device.uid, device_token).get
      resp.status.should == 200
      resp.body.should == tags
    end
  end
end
