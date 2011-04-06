require 'spec_helper'

describe FiveMobilePush::Platform do
  describe '.new' do
    it 'sets a list of target platforms' do
      described_class.new(FiveMobilePush::Platform::ALL).
        target_platforms.should include(FiveMobilePush::Platform::ALL)
    end
  end

  describe '#build_list' do
    subject { Fabricate.build(:platform) }

    it 'includes each targetted platform' do
      subject.target_platforms.all? { |p| subject.build_list.include?(p) }.should be_true
    end

    it 'separates values by a comma' do
      subject.build_list.should =~ /.+,.+/
    end
  end

  describe '#target_platforms=' do
    it 'flattens the provided argument' do
      subject.target_platforms = [[FiveMobilePush::Platform::ALL]]
      subject.target_platforms.should == [FiveMobilePush::Platform::ALL]
    end
  end
end
