require 'spec_helper'

require_relative '../../lib/smbglobal_sms/response'

module SmbglobalSms
  describe Response do
    let(:body) { "<response><status>100</status><credits>4500</credits></response>" }

    describe ".initialize" do
      it "accepts Faraday's response body" do
        response = Response.new(body)
      end

      it "inject the XML into Nokogiri parser" do
        Nokogiri.should_receive(:XML).with(body)
        response = Response.new(body)
      end
    end

    describe "#status" do
      it "knows the status of the response" do
        response = Response.new(body)
        expect(response.status).to eq(100)
      end
    end

    describe "#credits" do
      it "knows the remaining credits" do
        response = Response.new(body)
        expect(response.credits).to eq(4500)
      end
    end

    describe "#success?" do
      it "positive status will be considered as successful" do
        response = Response.new(body)
        expect(response.success?).to be_true
      end

      it "negative status will be considered as unsuccessful" do
        body = "<response><status>-1</status><credits /></response>"
        response = Response.new(body)
        expect(response.success?).not_to be_true
      end
    end
  end
end
