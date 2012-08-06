# Smbglobal::Sms

[![Build
Status](https://secure.travis-ci.org/mech/smbglobal-sms.png?branch=master)](http://travis-ci.org/mech/smbglobal-sms)
[![Code
Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/mech/smbglobal-sms)

This gem is a wrapper to send SMS using
[SMBGlobal](http://www.smbglobal.net/web-based-sms-system.html) HTTP API.

## Installation

Add this line to your application's Gemfile:

    gem 'smbglobal-sms'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install smbglobal-sms

## Configuration

We get credential from your environment variables, please set your API's
username and password via:

    SMBGLOBAL_USERNAME
    SMBGLOBAL_PASSWORD

To overwrite the host name, you can create a `smbglobal_sms.rb` file:

    SmbglobalSms.configure do |config|
      config.host_name = "api.smbglobal.net"
    end

## Usage

You need to create a `SmbglobalSms::Request` object in order to send
SMS.

    request  = SmbglobalSms::Request.new
    response = request.send_sms("Meet you at 5", 67656765, 98765676)

A `SmbglobalSms::Response` object will be returned to you to check for
status and remaining credits.

    response.status  #=> "OK", "NOT OK"
    response.reason  #=> "Not enough credit", "Wrong credential"
    response.credits #=> 4500

Please note that credits reflected has been normalized, which means if
you see 4500 credits left, you can send 4500 more SMS messages.
SMBGlobal usually uses 4 credits for 1 SMS message, but in order to
simplify thing, we will use 1 credit for 1 SMS message.

## Unicode string for SMS

See http://sms.24cro.com/op_1_4_en.htm

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
