# -*- encoding: utf-8 -*-
require File.expand_path('../lib/smbglobal_sms/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["mech"]
  gem.email         = ["mech@me.com"]
  gem.description   = "A wrapper to SMBGlobal SMS service"
  gem.summary       = "Send SMS using SMBGlobal API service"
  gem.homepage      = "https://github.com/mech/smbglobal-sms"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec|features)/})
  gem.name          = "smbglobal-sms"
  gem.require_paths = ["lib"]
  gem.version       = SmbglobalSms::VERSION

  gem.add_dependency "faraday", "0.8.1"
  gem.add_dependency "nokogiri", "~> 1.5"
  gem.add_dependency "uuid", "2.3.5"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "~> 2.11"
  gem.add_development_dependency "yard"
  gem.add_development_dependency "redcarpet"
end
