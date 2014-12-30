require 'latchsdk'
require 'logger'

module Devise
  module Models
    module Latchable
      extend ActiveSupport::Concern

      attr_reader :token

      ERROR_CODES = {
        206 => 'invalid_token',
        205 => 'already_paired'
      }

      included do
        before_destroy :unpair_user
      end

      @@logger = Logger.new(STDOUT)
      @@api = Latch.new(::Devise.latch_appid, Devise.latch_appsecret)

      def active_for_authentication?
        super && self.is_latch_active?
      end

      def pair token
        pair_result = @@api.pair(token)
        if pair_result.error
          self.errors.add(:token, ERROR_CODES[pair_result.error.code])
        else
          self.latch_account_id = pair_result.data.account_id
          save(validate: false)
        end
        @@logger.debug("Pair user #{token} #{pair_result.data.to_json} #{pair_result.error.to_json}")
      end

      def unpair
        @@logger.debug("unpair user #{self.id.to_s}")
        @@api.unpair(self.account_id)
      end

      def paired?
        self.account_id.nil?
      end

      protected

      def is_latch_active?
        is_active_data = @@api.status(self.id.to_s).error
        @@logger.debug("Is Active user #{self.id.to_s}? #{is_active_data.to_json}")
        true
      end

    end
  end
end
