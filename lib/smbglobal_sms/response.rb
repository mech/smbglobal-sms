require 'nokogiri'

module SmbglobalSms
  class Response
    # Accepts a response body which represent XML, then parse it.
    #
    # @param [String] body the response.body of SmbglobalSms::Request
    def initialize(body)
      @doc = Nokogiri::XML(body)
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
  end
end
