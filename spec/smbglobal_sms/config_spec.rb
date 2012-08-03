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
      xml_unicode_sms_end_point = "/api/sendunicodesms2"

      SmbglobalSms.configure do |config|
        config.host_name = host_name
        config.xml_unicode_sms_end_point = xml_unicode_sms_end_point
      end

      SmbglobalSms.configuration.host_name.should == host_name
      SmbglobalSms.configuration.xml_unicode_sms_end_point.should == xml_unicode_sms_end_point
    end
  end
end
