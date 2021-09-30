# frozen_string_literal: true

module Decidim
  module Civicrm
    module Verifications
      class GroupActionAuthorizer < Decidim::Verifications::DefaultActionAuthorizer
        def authorize
          return [:missing, { action: :authorize }] if authorization.blank? || contact.blank?

          status_code = :unauthorized

          return [status_code, { fields: { "civicrm_groups": "..." } }] if groups.blank? || matching_groups.empty?
          return [:ok, {}] if matching_groups.any?

          [:incomplete, {}]
        end

        private

        def allowed_groups
          options["civicrm_groups"].reject(&:blank?).map(&:to_i)
        end

        def groups
          contact.groups.pluck(:civicrm_group_id)
        end

        def matching_groups
          (allowed_groups) & (groups)
        end

        def manifest
          @manifest ||= Decidim::Verifications.find_workflow_manifest(authorization&.name)
        end

        def contact
          authorization&.user&.contact
        end
      end
    end
  end
end
