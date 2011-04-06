require 'spec_helper'

describe FiveMobilePush do

  describe '.api_token' do

    it "sets the api_token" do
      subject.api_token = "random_key"
      subject.api_token.should == "random_key"
    end

  end

  describe '.application_uid' do

    it "sets the application_uid" do
      subject.application_uid = 'nulayer'
      subject.application_uid.should == 'nulayer'
    end

  end

  describe '.configure' do
    it 'can set the API token' do
      api_token = '12345'

      FiveMobilePush.configure do |config|
        config.api_token = api_token
      end

      FiveMobilePush.api_token.should == api_token
    end

    it 'can set the application UID' do
      application_uid = 'cheesebacon'

      FiveMobilePush.configure do |config|
        config.application_uid = application_uid
      end

      FiveMobilePush.application_uid.should == application_uid
    end
  end

end
