require 'spec_helper'

describe FiveMobilePush::Payload do
  describe '#to_json' do
    subject { Fabricate.build(:payload) }

    it 'includes the message' do
      subject.to_json.should include(subject.message)
    end

    it 'includes meta data' do
      subject.to_json.should include(MultiJson.encode(subject.meta_data))
    end

    it 'excludes meta data if there is none' do
      subject.meta_data = nil
      subject.to_json.should_not include('meta')
    end
  end
end
