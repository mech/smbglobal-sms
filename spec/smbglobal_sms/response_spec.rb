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
        expect(response.status).to eq("100")
      end
    end
  end
end
