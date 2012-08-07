module SmbglobalSms
  module Error
    # Status = -1
    class InvalidCredentialError < StandardError
      def message
        "Invalid username or password"
      end
    end

    # Status = -2 or -101
    class InvalidDataFormatError < StandardError
      def message
        "Data format incorrect"
      end
    end

    # Status = -3
    class NotEnoughCreditsError < StandardError
      def message
        "No more credit!"
      end
    end

    # Status = -4
    class InvalidRecipientError < StandardError
      def message
        "Please include country code like 65XXXXXXXX"
      end
    end

    # Status = -5
    class ProcessingError < StandardError
      def message
        "Processing error"
      end
    end

    # Status = -100
    class MissingParametersError < StandardError
      def message
        "Missing parameters"
      end
    end

    # Status = -102
    class DuplicatedRequestError < StandardError
      def message
        "Duplicated request"
      end
    end

    # Status = -103
    class ServiceUnavailableError < StandardError
      def message
        "SMS Service currently not available!"
      end
    end
  end
end
