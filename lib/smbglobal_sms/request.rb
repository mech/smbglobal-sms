# encoding: utf-8
require 'faraday'

require_relative 'response'
require_relative 'error'

module SmbglobalSms
  class Request
    attr_reader :connection

    # Prepare Faraday connection object
    def initialize
      @connection = Faraday.new(url: SmbglobalSms.configuration.host_name)
    end

    # Endpoint for sending unicode SMS and receiving back an XML response.
    #
    # @return [String] the endpoint without the payload
    def endpoint
      SmbglobalSms.configuration.xml_unicode_sms_end_point
    end

    # Part of the credential to the final endpoint. We get it from environment variable.
    #
    # @return [String]
    def username
      ENV["SMBGLOBAL_USERNAME"]
    end

    # The password of the credential to the final endpoint. Get it from environment variable.
    #
    # @return [String]
    def password
      ENV["SMBGLOBAL_PASSWORD"]
    end

    # Let Faraday connect to the API and send SMS.
    #
    # @param [Integer] id the transaction ID that you use to track SMS
    # @param [String] message the message body
    # @param [Array, #each] recipients 1 or more recipients' phone number
    # @param [String] sender if you want reply, replace it with a phone number
    # @return [SmbglobalSms::Response]
    def send_sms(id, message, recipients, sender="Jobline")
      recipients = recipients.map(&:to_s).map(&:strip).join(":")
      response = Response.new(response_body(id, message, recipients, sender))
    end

    private

    def response_body(id, message, recipients, sender)
      @connection.post(endpoint, {
        transactionid: id,
        username: username,
        password: password,
        sender: sender,
        binary: string_to_hex(message),
        recp: recipients}).body
    end

    # Convert a string into its hexadecimal counterpart
    #
    # @example
    #   string_to_hex("简讯测试") will produce 7b808baf6d4b8bd5
    def string_to_hex(string)
      string.unpack('U*').collect do |num|
        pad(num.to_s(16))
      end.join.downcase
    end

    def pad(s)
      if s.length >= 4
        s
      elsif s.length == 3
        "0#{s}"
      elsif s.length == 2
        "00#{s}"
      elsif s.length == 1
        "000#{s}"
      end
    end
  end
end
