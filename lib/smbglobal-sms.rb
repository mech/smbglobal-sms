require "smbglobal_sms/version"
require "smbglobal_sms/config"

autoload :Request, 'smbglobal_sms/request'
autoload :Response, 'smbglobal_sms/response'

SmbglobalSms.configure do |config|
  config.host_name = "http://api.smbglobal.net"
  config.xml_unicode_sms_end_point = "/api/sendunicodesms2"
  config.xml_sms_end_point = "/api/sendsms2"
end
