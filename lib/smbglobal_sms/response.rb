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
      "100"
    end
  end
end
