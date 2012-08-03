require "smbglobal_sms/version"
require "smbglobal_sms/config"

SmbglobalSms.configure do |config|
  config.host_name = "http://api.smbglobal.net"
  config.xml_unicode_sms_end_point = "/api/sendunicodesms2"
end
