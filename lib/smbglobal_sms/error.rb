module SmbglobalSms
  module Error
    # Status = -1
    class InvalidCredentialError < StandardError
    end

    # Status = -2 or -101
    class InvalidDataFormatError < StandardError
    end

    # Status = -3
    class NotEnoughCreditsError < StandardError
    end

    # Status = -4
    class InvalidRecipientError < StandardError
    end

    # Status = -5
    class ProcessingError < StandardError
    end

    # Status = -100
    class MissingParametersError < StandardError
    end

    # Status = -102
    class DuplicatedRequestError < StandardError
    end

    # Status = -103
    class ServiceUnavailableError < StandardError
    end
  end
end
