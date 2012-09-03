require "smbglobal_sms/version"
require "smbglobal_sms/config"
require "smbglobal_sms/request"
require "smbglobal_sms/response"

SmbglobalSms.configure do |config|
  config.host_name = "http://api.smbglobal.net"
  config.unicode_end_point = "/api/sendunicodesms2"
  config.ascii_end_point = "/api/sendsms2"
end
