require 'devise-authy/hooks/authy_authenticatable'
module Devise
  module Models
    module AuthyAuthenticatable
      extend ActiveSupport::Concern

      def with_authy_authentication?(request)
        self.authy_id.present? &&
        (request.cookies['authy_authentication'].blank? ||
          self.class.authy_expires_at.ago.to_datetime > self.last_sign_in_with_authy &&
          request.cookies['authy_authentication'] == 'true')
      end

      module ClassMethods
        Devise::Models.config(self, :authy_expires_at)
        def find_by_authy_id(authy_id)
          find(:first, :conditions => {:authy_id => authy_id})
        end
      end
    end
  end
end

