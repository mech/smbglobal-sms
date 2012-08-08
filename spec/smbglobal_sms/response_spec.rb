require 'spec_helper'

require_relative '../../lib/smbglobal_sms/response'

module SmbglobalSms
  describe Response do
    let(:body) { "<response><status>100</status><credits>4500</credits></response>" }

    describe ".initialize" do
      it "accepts Faraday's response body" do
        response = Response.new(body)
      end

      context "Error condition" do
        it "raises InvalidCredentialError if wrong credential" do
          body = "<response><status>-1</status><credits /></response>"
          expect { Response.new(body) }.to raise_error(Error::InvalidCredentialError)
        end

        it "raises InvalidDataFormatError if data format is wrong" do
          body = "<response><status>-2</status><credits /></response>"
          expect { Response.new(body) }.to raise_error(Error::InvalidDataFormatError)
        end

        it "raises NotEnoughCreditsError if credits are insufficient" do
          body = "<response><status>-3</status><credits /></response>"
          expect { Response.new(body) }.to raise_error(Error::NotEnoughCreditsError)
        end

        it "raises InvalidRecipientError if wrong recipient" do
          body = "<response><status>-4</status><credits /></response>"
          expect { Response.new(body) }.to raise_error(Error::InvalidRecipientError)
        end

        it "raises ProcessingError if processing hiccup" do
          body = "<response><status>-5</status><credits /></response>"
          expect { Response.new(body) }.to raise_error(Error::ProcessingError)
        end

        it "raises MissingParametersError if parameters are missing" do
          body = "<response><status>-100</status><credits /></response>"
          expect { Response.new(body) }.to raise_error(Error::MissingParametersError)
        end

        it "raises DuplicatedRequestError if request is duplicated" do
          body = "<response><status>-102</status><credits /></response>"
          expect { Response.new(body) }.to raise_error(Error::DuplicatedRequestError)
        end

        it "raises ServiceUnavailableError if server down" do
          body = "<response><status>-103</status><credits /></response>"
          expect { Response.new(body) }.to raise_error(Error::ServiceUnavailableError)
        end

        it "raises InvalidDataFormatError if data format is wrong" do
          body = "<response><status>-101</status><credits /></response>"
          expect { Response.new(body) }.to raise_error(Error::InvalidDataFormatError)
        end
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
        expect(response.credits).to eq(1125)
      end
    end

    describe "#success?" do
      it "positive status will be considered as successful" do
        response = Response.new(body)
        expect(response.success?).to be_true
      end
    end
  end
end
