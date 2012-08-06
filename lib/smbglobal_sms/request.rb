require 'faraday'

require_relative 'response'
require_relative 'error'

module SmbglobalSms
  class Request
    attr_reader :connection

    # Prepare the message to be sent to one or several recipients.
    #
    # @example
    #   request = Request.new
    #   request.send_sms([67656765, 98765676], "Meet you at 5")
    # @param [String] message the sms message
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

      response = @connection.post(endpoint, {
        transactionid: id,
        username: username,
        password: password,
        sender: sender,
        text: message,
        recp: recipients})

      _response = Response.new(response.body)

      if _response.success?
        return _response
      else
        if _response.status == -1
          raise Error::InvalidCredentialError
        end
      end
    end
  end
end