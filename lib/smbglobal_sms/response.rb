require 'nokogiri'

require_relative 'error'

module SmbglobalSms
  class Response
    # Accepts a response body which represent XML, then parse it.
    #
    # @param [String] body the response.body of SmbglobalSms::Request
    def initialize(body)
      @doc = Nokogiri::XML(body)

      unless success?
        report_error
      end
    end

    def status
      @doc.xpath('//status').first.text.to_i
    end

    def credits
      @doc.xpath('//credits').first.text.to_i
    end

    def success?
      status > 0 ? true : false
    end

    private

    def report_error
      if status == -1
        raise Error::InvalidCredentialError
      elsif status == -2 || status == -101
        raise Error::InvalidDataFormatError
      elsif status == -3
        raise Error::NotEnoughCreditsError
      elsif status == -4
        raise Error::InvalidRecipientError
      elsif status == -5
        raise Error::ProcessingError
      elsif status == -100
        raise Error::MissingParametersError
      elsif status == -102
        raise Error::DuplicatedRequestError
      elsif status == -103
        raise Error::ServiceUnavailableError
      end
    end
  end
end
