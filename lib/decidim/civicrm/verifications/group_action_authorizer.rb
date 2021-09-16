# frozen_string_literal: true

module Decidim
  module Civicrm
    module Verifications
      class GroupActionAuthorizer < Decidim::Verifications::DefaultActionAuthorizer
        def authorize
          return super if manifest.blank?

          group_ids = manifest.options&.group_ids.split(",").map(&:to_i)

          status_code = :ok if belongs_to_group?(group_ids)

          [status_code, data]
        end

        def belongs_to_group?(group_ids)
          return unless group_ids.any?

          matching_groups = contact.groups.pluck(:civicrm_group_id) & (group_ids)
          matching_groups.any?
        end

        def contact
          Decidim::Civicrm::Contact.find_by(user: authorization.user)
        end

        def manifest
          @manifest ||= Decidim::Verifications.find_workflow_manifest(authorization&.name)
        end
      end
    end
  end
end
