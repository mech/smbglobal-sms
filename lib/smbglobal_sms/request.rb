require 'faraday'

require_relative 'response'

module SmbglobalSms
  class Request
    attr_accessor :recipients, :message
    attr_reader :connection

    # Prepare the message to be sent to one or several recipients.
    #
    # @example
    #   request = Request.new([67656765, 98765676], "Meet you at 5")
    #   request.send_sms
    # @param [Array, #each] recipients 1 or more recipients' phone number
    # @param [String] message the sms message
    def initialize(recipients, message)
      @recipients = recipients
      @message = message
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
    # @return [SmbglobalSms::Response]
    def send_sms
      response = @connection.post(endpoint)
      Response.new(response.body)
    end
  end
end
