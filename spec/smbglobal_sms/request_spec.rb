require 'spec_helper'

require_relative '../../lib/smbglobal_sms/request'

module SmbglobalSms
  describe Request do
    let(:request)   { Request.new }
    let(:recipient) { "98752616" }
    let(:message)   { "Hello, World!" }
    let(:host_name) { SmbglobalSms.configuration.host_name }
    let(:xml_unicode_sms_end_point) { SmbglobalSms.configuration.xml_unicode_sms_end_point }

    before { ENV.stub(:[]) } # Avoid "Please stub a default value first if message might be received with other args as well"

    describe ".initialize" do
      it "set up a Faraday connection object" do
        connection = stub
        Faraday.should_receive(:new).with(url: host_name).and_return(connection)
        expect(request.connection).to eq(connection)
      end
    end

    describe "#endpoint" do
      it "knows the request endpoint for sending SMS" do
        expect(request.endpoint).to eq(xml_unicode_sms_end_point)
      end
    end

    describe "#username" do
      it "gets username from the environment variable SMBGLOBAL_USERNAME" do
        ENV.stub(:[]).with("SMBGLOBAL_USERNAME").and_return("ABC")
        expect(request.username).to eq("ABC")
      end
    end

    describe "#password" do
      it "gets password from the environment variable SMBGLOBAL_PASSWORD" do
        ENV.stub(:[]).with("SMBGLOBAL_PASSWORD").and_return("DEF")
        expect(request.password).to eq("DEF")
      end
    end

    describe "#send_sms" do
      let(:payload) do
        {
          transactionid: 1,
          username: request.username,
          password: request.password,
          sender: "Jobline",
          text: message,
          recp: recipient
        }
      end

      it "returns a response object" do
        res = stub(body: "<response><status>200</status><credit>4500</credits></response>")
        request.connection.should_receive(:post).with(request.endpoint, payload).and_return(res)
        response = request.send_sms(1, message, [recipient])
        expect(response.class).to eq(SmbglobalSms::Response)
        expect(response.status).to eq(200)
      end

      context "Invalid credential" do
        it "raises InvalidCredentialError" do
          res = stub(body: "<response><status>-1</status><credits /></response>")
          request.connection.should_receive(:post).with(request.endpoint, payload).and_return(res)
          expect { request.send_sms(1, message, [recipient]) }.to raise_error(Error::InvalidCredentialError)
        end
      end
    end
  end
end
