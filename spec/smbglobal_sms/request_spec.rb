# encoding: utf-8
require 'spec_helper'

require_relative '../../lib/smbglobal_sms/request'

module SmbglobalSms
  describe Request do
    let(:request)   { Request.new }
    let(:recipient) { "98752616" }
    let(:message)   { "Hello, World!" }
    let(:host_name) { SmbglobalSms.configuration.host_name }
    let(:unicode_end_point) { SmbglobalSms.configuration.unicode_end_point }
    let(:ascii_end_point) { SmbglobalSms.configuration.ascii_end_point }

    before { ENV.stub(:[]) } # Avoid "Please stub a default value first if message might be received with other args as well"

    describe ".initialize" do
      it "set up a Faraday connection object" do
        connection = stub
        Faraday.should_receive(:new).with(url: host_name).and_return(connection)
        expect(request.connection).to eq(connection)
      end
    end

    describe "#unicode_end_point" do
      it "knows the request endpoint for sending Unicode SMS" do
        expect(request.unicode_end_point).to eq(unicode_end_point)
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

    describe "#send_ascii_sms" do
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
        request.connection.should_receive(:post).with(request.ascii_end_point, payload).and_return(res)
        response = request.send_ascii_sms(1, message, [recipient])
        expect(response.class).to eq(SmbglobalSms::Response)
        expect(response.status).to eq(200)
      end

      context "Error conditions" do
        it "raises InvalidCredentialError if wrong credential" do
          res = stub(body: "<response><status>-1</status><credits /></response>")
          request.connection.should_receive(:post).with(request.ascii_end_point, payload).and_return(res)
          expect { request.send_ascii_sms(1, message, [recipient]) }.to raise_error(Error::InvalidCredentialError)
        end

        it "raises InvalidDataFormatError if data format is wrong" do
          res = stub(body: "<response><status>-2</status><credits /></response>")
          request.connection.should_receive(:post).with(request.ascii_end_point, payload).and_return(res)
          expect { request.send_ascii_sms(1, message, [recipient]) }.to raise_error(Error::InvalidDataFormatError)
        end

        it "raises NotEnoughCreditsError if credits are insufficient" do
          res = stub(body: "<response><status>-3</status><credits /></response>")
          request.connection.should_receive(:post).with(request.ascii_end_point, payload).and_return(res)
          expect { request.send_ascii_sms(1, message, [recipient]) }.to raise_error(Error::NotEnoughCreditsError)
        end

        it "raises InvalidRecipientError if wrong recipient" do
          res = stub(body: "<response><status>-4</status><credits /></response>")
          request.connection.should_receive(:post).with(request.ascii_end_point, payload).and_return(res)
          expect { request.send_ascii_sms(1, message, [recipient]) }.to raise_error(Error::InvalidRecipientError)
        end

        it "raises ProcessingError if processing hiccup" do
          res = stub(body: "<response><status>-5</status><credits /></response>")
          request.connection.should_receive(:post).with(request.ascii_end_point, payload).and_return(res)
          expect { request.send_ascii_sms(1, message, [recipient]) }.to raise_error(Error::ProcessingError)
        end

        it "raises MissingParametersError if parameters are missing" do
          res = stub(body: "<response><status>-100</status><credits /></response>")
          request.connection.should_receive(:post).with(request.ascii_end_point, payload).and_return(res)
          expect { request.send_ascii_sms(1, message, [recipient]) }.to raise_error(Error::MissingParametersError)
        end

        it "raises DuplicatedRequestError if request is duplicated" do
          res = stub(body: "<response><status>-102</status><credits /></response>")
          request.connection.should_receive(:post).with(request.ascii_end_point, payload).and_return(res)
          expect { request.send_ascii_sms(1, message, [recipient]) }.to raise_error(Error::DuplicatedRequestError)
        end

        it "raises ServiceUnavailableError if server down" do
          res = stub(body: "<response><status>-103</status><credits /></response>")
          request.connection.should_receive(:post).with(request.ascii_end_point, payload).and_return(res)
          expect { request.send_ascii_sms(1, message, [recipient]) }.to raise_error(Error::ServiceUnavailableError)
        end

        it "raises InvalidDataFormatError if data format is wrong" do
          res = stub(body: "<response><status>-101</status><credits /></response>")
          request.connection.should_receive(:post).with(request.ascii_end_point, payload).and_return(res)
          expect { request.send_ascii_sms(1, message, [recipient]) }.to raise_error(Error::InvalidDataFormatError)
        end
      end
    end

    describe "#send_unicode_sms" do
      let(:payload) do
        {
          transactionid: 1,
          username: request.username,
          password: request.password,
          sender: "Jobline",
          binary: request.__send__(:string_to_hex, message),
          recp: recipient
        }
      end

      it "returns a response object" do
        res = stub(body: "<response><status>200</status><credit>4500</credits></response>")
        request.connection.should_receive(:post).with(request.unicode_end_point, payload).and_return(res)
        response = request.send_unicode_sms(1, message, [recipient])
        expect(response.class).to eq(SmbglobalSms::Response)
        expect(response.status).to eq(200)
      end

      context "Error conditions" do
        it "raises InvalidCredentialError if wrong credential" do
          res = stub(body: "<response><status>-1</status><credits /></response>")
          request.connection.should_receive(:post).with(request.unicode_end_point, payload).and_return(res)
          expect { request.send_unicode_sms(1, message, [recipient]) }.to raise_error(Error::InvalidCredentialError)
        end

        it "raises InvalidDataFormatError if data format is wrong" do
          res = stub(body: "<response><status>-2</status><credits /></response>")
          request.connection.should_receive(:post).with(request.unicode_end_point, payload).and_return(res)
          expect { request.send_unicode_sms(1, message, [recipient]) }.to raise_error(Error::InvalidDataFormatError)
        end

        it "raises NotEnoughCreditsError if credits are insufficient" do
          res = stub(body: "<response><status>-3</status><credits /></response>")
          request.connection.should_receive(:post).with(request.unicode_end_point, payload).and_return(res)
          expect { request.send_unicode_sms(1, message, [recipient]) }.to raise_error(Error::NotEnoughCreditsError)
        end

        it "raises InvalidRecipientError if wrong recipient" do
          res = stub(body: "<response><status>-4</status><credits /></response>")
          request.connection.should_receive(:post).with(request.unicode_end_point, payload).and_return(res)
          expect { request.send_unicode_sms(1, message, [recipient]) }.to raise_error(Error::InvalidRecipientError)
        end

        it "raises ProcessingError if processing hiccup" do
          res = stub(body: "<response><status>-5</status><credits /></response>")
          request.connection.should_receive(:post).with(request.unicode_end_point, payload).and_return(res)
          expect { request.send_unicode_sms(1, message, [recipient]) }.to raise_error(Error::ProcessingError)
        end

        it "raises MissingParametersError if parameters are missing" do
          res = stub(body: "<response><status>-100</status><credits /></response>")
          request.connection.should_receive(:post).with(request.unicode_end_point, payload).and_return(res)
          expect { request.send_unicode_sms(1, message, [recipient]) }.to raise_error(Error::MissingParametersError)
        end

        it "raises DuplicatedRequestError if request is duplicated" do
          res = stub(body: "<response><status>-102</status><credits /></response>")
          request.connection.should_receive(:post).with(request.unicode_end_point, payload).and_return(res)
          expect { request.send_unicode_sms(1, message, [recipient]) }.to raise_error(Error::DuplicatedRequestError)
        end

        it "raises ServiceUnavailableError if server down" do
          res = stub(body: "<response><status>-103</status><credits /></response>")
          request.connection.should_receive(:post).with(request.unicode_end_point, payload).and_return(res)
          expect { request.send_unicode_sms(1, message, [recipient]) }.to raise_error(Error::ServiceUnavailableError)
        end

        it "raises InvalidDataFormatError if data format is wrong" do
          res = stub(body: "<response><status>-101</status><credits /></response>")
          request.connection.should_receive(:post).with(request.unicode_end_point, payload).and_return(res)
          expect { request.send_unicode_sms(1, message, [recipient]) }.to raise_error(Error::InvalidDataFormatError)
        end
      end
    end

    # Test for a private method :(
    describe "#string_to_hex" do
      it "converts '简讯测试' to 7b808baf6d4b8bd5" do
        s = request.__send__(:string_to_hex, "简讯测试")
        expect(s).to eq("7b808baf6d4b8bd5")
      end

      it "converts Confident Ruby into 0043006f006e0066006900640065006e007400200052007500620079" do
        s = request.__send__(:string_to_hex, "Confident Ruby")
        expect(s).to eq("0043006f006e0066006900640065006e007400200052007500620079")
        # 436f6e666964656e742052756279
      end

      it "converts 'こんにちは' into 30533093306b3061306f" do
        s = request.__send__(:string_to_hex, "こんにちは")
        expect(s).to eq("30533093306b3061306f")
      end

      it "converts 'Demo 简' into 00440065006d006f00207b80" do
        s = request.__send__(:string_to_hex, "Demo 简")
        expect(s).to eq("00440065006d006f00207b80")
        # 0043006f006e0066006900640065006e007400200052007500620079
      end

      it "converts 'Demo' into 00440065006d006f" do
        s = request.__send__(:string_to_hex, "Demo")
        expect(s).to eq("00440065006d006f")
      end

      it "converts 'Confident Rubyこんにちは' into 0043006f006e0066006900640065006e00740020005200750062007930533093306b3061306f" do
        s = request.__send__(:string_to_hex, "Confident Rubyこんにちは")
        expect(s).to eq("0043006f006e0066006900640065006e00740020005200750062007930533093306b3061306f")
      end

      it "converts 'Confident\r\rRuby' into ?" do
        s = request.__send__(:string_to_hex, "Confident\r\rRuby")
        expect(s).to eq("0043006f006e0066006900640065006e0074000d000d0052007500620079")
      end

      it "converts 'Confident\r\nRuby' into ?" do
        s = request.__send__(:string_to_hex, "Confident\r\nRuby")
        expect(s).to eq("0043006f006e0066006900640065006e0074000d000a0052007500620079")
      end
    end
  end
end
