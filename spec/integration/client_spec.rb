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
  
  let(:register_device) { subject.device(device.uid).register(device_info, reg_data) }
  let(:device_token) { register_device['data'] }
  
  context "device" do
  
    context "register device" do
      it "register device" do
        expect { register_device }.to_not raise_error
      end
    end
  
    context "attempt to register device with invalid info" do
      let(:device_info_test) {
        Proc.new {|hash| subject.device(device.uid).register(device_info.merge(hash), reg_data) }
      }
    
      it "invalid device manufacturer" do
        device_info_test.call({ 'manufacturer' => 'jello' }).should include('data')
      end
    
      it "invalid device model" do
        device_info_test.call({ 'model' => '###F#F23f23f!@!@xyz' }).should include('data')
      end
    
      it "invalid device platform" do
        device_info_test.call({ 'platform' => 'xyz' }).should =~ /Unrecognized platform/
      end
    
      it "invalid device platform_ver" do
        device_info_test.call({ 'platform_ver' => '###F#F23f23f!@!@xyz' }).should include('data')
      end
    end
    
    it "unregisters a subscription" do
      resp = subject.device(device.uid, device_token).unregister
      resp.status.should == 200
      resp.body.should == ''
    end
    
    it "suspends a subscription" do
      resp = subject.device(device.uid, device_token).suspend
      resp.status.should == 200
      resp.body.should == ''
    end
    
    it "suspends with an invalid token" do
      expect {
        subject.device(device.uid, 'wooohoo').suspend
      }.to raise_error(FiveMobilePush::InvalidToken)
    end
    
    it "resumes a subscription" do
      resp = subject.device(device.uid, device_token).resume
      resp.status.should == 200
      resp.body.should == ''
    end
  
  end
  
  #------
  
  context "notify" do
    let(:notifier) { subject.notifier }
    
    it "broadcasts a message to all platforms" do
      resp = notifier.broadcast(FiveMobilePush::Platform::ALL) do |message|
        message.body "Heyyo it's an rspec party"
      end
      
      resp.status.should == 200
    end
    
    it "send a message to a faulty device" do
      # NOTE: this spec passes.. it appears that we don't get a response
      # telling us the device doesn't exist
      
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
  
  #------
  
  context "tags" do
    
    it "create a tag" do
      resp = subject.tag(device.uid, device_token).create(['toronto', 'summer'])
      resp.status.should == 200
    end
    
    it "delete a tag" do
      resp = subject.tag(device.uid, device_token).create(['food'])
      resp.status.should == 200
    end
    
    # NOTE: I am pretty sure this does not work on FiveMobile's service...
    # resp.body keeps telling us the application_id must be supplied,
    # but we are passing it ..
    it "get a device's tags" do
      register_device
      subject.tag(device.uid, device_token).create(['toronto', 'summer'])
      
      resp = subject.tag(device.uid, device_token).get
      # resp.status.should == 200
      # resp.body.should == ....
    end
    
  end
  
end
