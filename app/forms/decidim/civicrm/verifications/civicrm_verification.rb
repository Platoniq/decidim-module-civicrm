# frozen_string_literal: true

require "digest"

module Decidim
  module Civicrm
    module Verifications
      class CivicrmVerification < Decidim::AuthorizationHandler
        validate :user_valid

        def metadata
          super.merge(
            contact_id: uid
          )
        end

        def unique_id
          Digest::SHA512.hexdigest(
            "#{uid}-#{Rails.application.secrets.secret_key_base}"
          )
        end

        # def to_partial_path
        #   "civicrm/form"
        # end

        private

        def organization
          current_organization || user&.organization
        end

        def uid
          user.identities.find_by(organization: organization, provider: PROVIDER_NAME)&.uid
        end

        def civicrm_contact
          @civicrm_contact ||= Decidim::Civicrm::Contact.find_by(decidim_user: user)
        end

        def civicrm_api_contact
          @civicrm_api_contact ||= Decidim::Civicrm::Api::FindUser.new(uid).result
        end

        def user_valid
          errors.add(:user, "decidim.civicrm.errors.not_found") if civicrm_contact.blank? && civicrm_api_contact.blank?
        end
      end
    end
  end
end
