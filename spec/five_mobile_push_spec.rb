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
  
  describe '.id_type' do
    
    it "sets the id_type" do
      subject.id_type = 'native'
      subject.id_type.should == 'native'
    end
    
  end
  
  
  describe 'configure' do

    FiveMobilePush::VALID_OPTION_KEYS.each do |key|
      
      it "sets the key #{key}" do
        FiveMobilePush.configure do |config|
          config.send("#{key}=", key)
        end
        FiveMobilePush.send(key).should == key
      end
      
    end

  end

  describe 'platforms' do
    
    %w(iphone blackberry android).each do |platform|
      
      specify { FiveMobilePush::SUPPORTED_PLATFORMS.should include(platform) }
      
    end
    
  end
  
end
