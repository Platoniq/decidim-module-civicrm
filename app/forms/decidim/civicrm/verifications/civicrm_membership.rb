# frozen_string_literal: true

require "digest"

module Decidim
  module Civicrm
    module Verifications
      class CivicrmMembership < CivicrmBasic
        validate :user_valid

        def metadata
          super.merge(
            civicrm_membership_types: civircm_memberships
          )
        end

        def unique_id
          Digest::SHA512.hexdigest(
            "#{uid}-civicrm-membership-#{Rails.application.secrets.secret_key_base}"
          )
        end

        private

        def civircm_memberships
          @civircm_memberships ||= civicrm_api_contact[:memberships]
        end

        def user_valid
          super

          return if errors.any?

          errors.add(:user, "decidim.civicrm.errors.not_found") unless civicrm_api_contact&.has_key?(:memberships)
        end
      end
    end
  end
end
