# frozen_string_literal: true

require "digest"

module Decidim
  module Civicrm
    module Verifications
      class CivicrmMembershipTypes < Decidim::Civicrm::Verifications::Civicrm
        def metadata
          super.merge(
            membership_types_ids: civicrm_membership_types.pluck(:civicrm_membership_type_id)
          )
        end

        def unique_id
          Digest::SHA512.hexdigest(
            "membership_types-#{uid}-#{Rails.application.secrets.secret_key_base}"
          )
        end

        private

        def civicrm_membership_types
          @civicrm_membership_types ||= Decidim::Civicrm::MembershipType.where(civicrm_membership_type_id: civicrm_contact&.membership_types)
        end
      end
    end
  end
end
