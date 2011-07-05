require 'spec_helper'

FiveMobilePush.configure do |config|
  config.api_token        = ''
  config.application_uid  = ''
end

describe FiveMobilePush::Client do
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

  subject { described_class.new }
  
  it "register device" do
    expect {
      subject.device(device.uid).register(device_info, reg_data)
    }.to_not raise_error
  end
end
