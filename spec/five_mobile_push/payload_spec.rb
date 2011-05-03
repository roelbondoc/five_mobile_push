require 'spec_helper'

describe FiveMobilePush::Payload do
  describe '#meta_data=' do
    subject { Fabricate.build(:payload) }

    it 'sets meta data' do
      subject.meta_data = meta_data = { a: 'b' }
      subject.meta_data.should == meta_data
    end

    it 'raises an ArgumentError if a Hash is not provided' do
      expect {
        subject.meta_data = nil
      }.to raise_error(ArgumentError, 'meta_data must be a Hash')
    end
  end

  describe '#to_json' do
    subject { Fabricate.build(:payload) }

    it 'includes the message' do
      subject.to_json.should include(subject.message)
    end

    it 'includes any meta data' do
      subject.meta_data = { a: 'b' }
      subject.to_json.should include('"a":"b"')
    end
  end
end
