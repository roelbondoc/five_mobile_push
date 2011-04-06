require 'spec_helper'
require 'uri'

describe FiveMobilePush::Notifier do

  let(:client) { Fabricate.build(:client) }

  subject { FiveMobilePush::Notifier.new(client) }

  describe "#broadcast" do
    let(:broadcast_endpoint) { notifier_endpoint('broadcast') }

    it "broadcasts a notification to one or more platforms of the application" do
      stub_request(:post, broadcast_endpoint)

      subject.broadcast(:iphone) do |message|
        message.body "Minor downtime tonight from 7PM-9PM EST"
      end

      a_request(:post, broadcast_endpoint).should have_been_made
    end

  end

  describe '#notify_devices' do

    let(:notify_devices_endpoint) { notifier_endpoint('toDevices') }

    it "notifies a list of devices" do
      stub_request(:post, notify_devices_endpoint)

      subject.notify_devices(['abc', 'def']) do |message|
        message.body 'You win a prize!'
      end

      a_request(:post, notify_devices_endpoint).should have_been_made
    end

  end

  describe "#notify_by_tags" do

    let(:notify_by_tags_endpoint) { notifier_endpoint('toTags') }

    it "notifies devices by tags" do
      stub_request(:post, notify_by_tags_endpoint)

      subject.notify_by_tags([:iphone, :android], ['tag1', 'tag2']) do |message|
        message.body 'tag1 and tag2'
      end

      a_request(:post, notify_by_tags_endpoint).should have_been_made
    end

  end

  def notifier_endpoint(name)
    "https://push.fivemobile.com/rest/notify/#{name}"
  end

end
