require 'spec_helper'

describe FiveMobilePush::Tag do

  let(:api_token) { 'token' }
  let(:application_uid) { 'nulayer' }
  let(:client) { FiveMobilePush::Client.new :api_token => api_token, :application_uid => application_uid }
  let(:device_uid) { 'ABCD123' }

  subject { FiveMobilePush::Tag.new client, device_uid }

  describe "#create" do

    let(:add_tag_endpoint) { tag_endpoint('add') }
    let(:tags) { %w(tag1 tag2) }

    it "adds a new tag to Five Mobile" do
      body = build_request_body(:id_type => 'native', :id_value => device_uid, :tags => escape(tags.join(',')) )
      stub_request(:post, add_tag_endpoint).with(:body => body)
      subject.create tags
      a_request(:post, add_tag_endpoint).with(:body => body).should have_been_made
    end

  end

  describe "#delete" do
  end

  describe "#get" do
  end

  def tag_endpoint(name)
     "https://push.fivemobile.com/rest/device/tags/#{name}"
  end

end
