module SmbglobalSms
  class Request
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
    end
  end
end
