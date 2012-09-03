require 'spec_helper'

require_relative '../../lib/smbglobal_sms/configuration'

module SmbglobalSms
  describe Configuration do
    let(:configuration) { Configuration.new }

    it "configures host name" do
      host_name = "api.smbglobal.net"
      configuration.host_name = host_name
      expect(configuration.host_name).to eq(host_name)
    end

    it "configures unicode end-point" do
      end_point = "/api/sendunicodesms2"
      configuration.unicode_end_point = end_point
      expect(configuration.unicode_end_point).to eq(end_point)
    end

    it "configures ASCII end-point" do
      end_point = "/api/sendsms2"
      configuration.ascii_end_point = end_point
      expect(configuration.ascii_end_point).to eq(end_point)
    end
  end
end
