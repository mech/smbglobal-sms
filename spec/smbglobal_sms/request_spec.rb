require 'spec_helper'

require_relative '../../lib/smbglobal_sms/request'

module SmbglobalSms
  describe Request do
    it "takes multiple recipients" do
      Request.new([stub, stub], "Hello, World!")
    end
  end
end
