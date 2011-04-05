require 'spec_helper'

describe FiveMobilePush::Payload do
  describe '#to_json' do
    subject { FiveMobilePush::Payload.new('bacon', { 'foo' => 'bar' }) }

    it 'includes the message' do
      subject.to_json.should include('bacon')
    end

    it 'includes meta data' do
      subject.to_json.should include('foo', 'bar')
    end

    it 'excludes meta data if there is none' do
      subject.meta_data = nil
      subject.to_json.should_not include('meta')
    end
  end
end
