require 'spec_helper'

require_relative '../../lib/smbglobal_sms/request'

module SmbglobalSms
  describe Request do
    let(:message)   { "Hello, World!" }
    let(:host_name) { SmbglobalSms.configuration.host_name }
    let(:xml_unicode_sms_end_point) { SmbglobalSms.configuration.xml_unicode_sms_end_point }

    describe ".initialize" do
      it "takes multiple recipients" do
        request = Request.new([stub, stub], message)
        expect(request).to have(2).recipients
      end

      it "takes one message" do
        request = Request.new(stub, message)
        expect(request.message).to eq(message)
      end

      it "set up a Faraday connection object" do
        connection = stub
        Faraday.should_receive(:new).with(url: host_name).and_return(connection)
        request = Request.new([], message)
        expect(request.connection).to eq(connection)
      end
    end

    describe "#endpoint" do
      it "knows the request endpoint for sending SMS" do
        request = Request.new(stub, message)
        expect(request.endpoint).to eq(xml_unicode_sms_end_point)
      end
    end

    describe "#username" do
      it "gets username from the environment variable SMBGLOBAL_USERNAME" do
        request = Request.new(stub, message)
        ENV.stub(:[]).with("SMBGLOBAL_USERNAME").and_return("ABC")
        expect(request.username).to eq("ABC")
      end
    end

    describe "#password" do
      it "gets password from the environment variable SMBGLOBAL_PASSWORD" do
        request = Request.new(stub, message)
        ENV.stub(:[]).with("SMBGLOBAL_PASSWORD").and_return("DEF")
        expect(request.password).to eq("DEF")
      end
    end

    describe "#send_sms" do
      it "returns a response object" do
        request = Request.new([98752616], message)
        res = stub(body: "")
        request.connection.should_receive(:post).with(request.endpoint).and_return(res)
        Response.should_receive(:new).with(res.body)
        response = request.send_sms
      end

      it "carries the credential, recipients, and message payroll" do
        request = Request.new([98752616], message)
      end
    end
  end
end
