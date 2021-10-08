# frozen_string_literal: true

module Decidim
  module Civicrm
    module Verifications
      class CivicrmGroups < Decidim::Civicrm::Verifications::Civicrm
        def metadata
          super.merge(
            group_ids: civicrm_groups.pluck(:civicrm_group_id)
          )
        end

        def unique_id
          Digest::SHA512.hexdigest(
            "groups-#{uid}-#{Rails.application.secrets.secret_key_base}"
          )
        end

        private

        def civicrm_groups
          @civicrm_groups ||= Decidim::Civicrm::Group.joins(:group_memberships)
                                                     .where({
                                                              decidim_civicrm_group_memberships: {
                                                                civicrm_contact_id: civicrm_contact&.civicrm_contact_id
                                                              }
                                                            })
        end
      end
    end
  end
end
