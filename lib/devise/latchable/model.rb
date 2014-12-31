require 'latchsdk'

module Devise
  module Models
    module Latchable
      extend ActiveSupport::Concern

      attr_reader :token

      PAIR_ERROR_CODES = {
        206 => 'invalid_token',
        205 => 'already_paired',
        401 => 'missing_parameter'
      }

      included do
        before_destroy :unpair_user
      end

      @@api = Latch.new(::Devise.latch_appid, Devise.latch_appsecret)

      # Overwrite active_for_authentication? method, in order to deny any access
      # to devise protected resources when latch is locked
      def active_for_authentication?
        super && self.latch_unlocked?
      end

      # Method that, given a token, pairs the user to the application. It adds errors
      # to the model in case the API returns an error, or save the accountId otherwise
      def pair token
        pair_result = @@api.pair(token)
        if pair_result.error
          self.errors.add(:token, PAIR_ERROR_CODES[pair_result.error.code])
        else
          self.latch_account_id = pair_result.data['accountId']
          save(validate: false)
        end
      end

      # Method that unpairs the current user with the application
      def unpair
        @@api.unpair(self.latch_account_id)
        self.latch_account_id = nil
        save
      end

      # For the given user, returns true if the account has been paired
      def paired?
        !self.latch_account_id.nil?
      end

      # For the given user, returns true if latch is unlocked or the user has
      # not been paired
      def latch_unlocked?
        if self.paired?
          latch_status = @@api.status(self.latch_account_id)
          operations = latch_status.data['operations']
          operations[operations.keys.first]['status'] == 'on'
        else
          true
        end
      end

    end
  end
end
