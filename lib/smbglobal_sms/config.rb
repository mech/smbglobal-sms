require_relative 'configuration'

module SmbglobalSms
  extend self

  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    yield configuration if block_given?
  end
end
