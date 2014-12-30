require 'devise/latchable/latchable'

module Devise
  mattr_accessor :latch_appid
  @@latch_appid = ''

  mattr_accessor :latch_appsecret
  @@latch_appsecret = ''
end
