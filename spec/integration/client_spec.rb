require 'spec_helper'

FiveMobilePush.configure do |config|
  config.api_token        = 'x'
  config.application_uid  = 'y'
end

describe FiveMobilePush::Client do
  let(:device) { double('Device', id: 12345, uid: 'abcdef') }
  let(:device_info) {
    {
      'manufacturer' => 'Apple',
      'model'        => 'iPod Touch',
      'platform'     => 'iOS',
      'platform_ver' => '4.3.2'
    }
  }
  let(:reg_data) { 'cafebabe' }
  
  it "register device" do
    # debugger
    # a = 1
    
    client = FiveMobilePush::Client.new
    client.device(device.uid).register(device_info, reg_data)
  end
end
