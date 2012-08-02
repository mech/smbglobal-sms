require 'spec_helper'

require_relative '../../lib/smbglobal_sms/configuration'

module SmbglobalSms
  describe Configuration do
    let(:configuration) { Configuration.new }

    it "configures host name" do
      host_name = "api.smbglobal.net"
      configuration.host_name = host_name
      configuration.host_name.should == host_name
    end
  end
end
