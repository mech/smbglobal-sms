require 'spec_helper'

require_relative '../../lib/smbglobal_sms/config'

describe SmbglobalSms do
  describe "::configuration" do
    it "returns the same configuration object" do
      SmbglobalSms.configuration.should equal(SmbglobalSms.configuration)
    end
  end

  describe "::configure" do
    it "yields the configuration object" do
      SmbglobalSms.configure do |config|
        config.should equal(SmbglobalSms.configuration)
      end
    end

    it "setup configuration" do
      host_name = "api.smbglobal.net"
      unicode_end_point = "/api/sendunicodesms2"
      ascii_end_point = "/api/sendsms2"

      SmbglobalSms.configure do |config|
        config.host_name = host_name
        config.unicode_end_point = unicode_end_point
        config.ascii_end_point = ascii_end_point
      end

      SmbglobalSms.configuration.host_name.should == host_name
      SmbglobalSms.configuration.unicode_end_point.should == unicode_end_point
      SmbglobalSms.configuration.ascii_end_point.should == ascii_end_point
    end
  end
end
