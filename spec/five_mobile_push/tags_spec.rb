require 'spec_helper'

describe FiveMobilePush::Tag do

  let(:client)     { Fabricate.build(:client) }
  let(:device_uid) { 'ABCD123' }

  subject { FiveMobilePush::Tag.new(client, device_uid) }

  describe "#create" do

    let(:add_tag_endpoint) { tag_endpoint('add') }
    let(:tags) { %w(tag1 tag2) }

    it "adds new tags to Five Mobile" do
      body = build_request_body(client, :id_type => FiveMobilePush::DEFAULT_ID_TYPE, :id_value => device_uid, :tags => escape(tags.join(',')) )
      stub_request(:post, add_tag_endpoint).with(:body => body)
      subject.create tags
      a_request(:post, add_tag_endpoint).with(:body => body).should have_been_made
    end

    it "adds a new tag to Five Mobile" do
      body = build_request_body(client, :id_type => FiveMobilePush::DEFAULT_ID_TYPE, :id_value => device_uid, :tags => "cheese")
      stub_request(:post, add_tag_endpoint).with(:body => body)
      subject.create("cheese")
      a_request(:post, add_tag_endpoint).with(:body => body).should have_been_made
    end

  end

  describe "#delete" do

    let(:tags) { %w[tag1 tag2] }
    let(:delete_tag_endpoint) { tag_endpoint("delete") }

    it "unsubscribes from further notifications for tags" do
      body = build_request_body(client, :id_type => FiveMobilePush::DEFAULT_ID_TYPE, :id_value => device_uid, :tags => escape(tags.join(',')))
      stub_request(:post, delete_tag_endpoint).with(:body => body)
      subject.delete(tags)
      a_request(:post, delete_tag_endpoint).with(:body => body).should have_been_made
    end

    it "unsubscribes from further notifications for tag" do
      body = build_request_body(client, :id_type => FiveMobilePush::DEFAULT_ID_TYPE, :id_value => device_uid, :tags => "bacon")
      stub_request(:post, delete_tag_endpoint).with(:body => body)
      subject.delete("bacon")
      a_request(:post, delete_tag_endpoint).with(:body => body).should have_been_made
    end

  end

  def tag_endpoint(name)
    (FiveMobilePush::Client::DEFAULT_ENDPOINT + "tags/#{name}").to_s
  end

end
