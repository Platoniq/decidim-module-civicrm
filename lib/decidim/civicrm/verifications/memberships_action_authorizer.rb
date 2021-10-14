# frozen_string_literal: true

module Decidim
  module Civicrm
    module Verifications
      class MembershipsActionAuthorizer < Decidim::Verifications::DefaultActionAuthorizer
        def authorize
          return [:missing, { action: :authorize }] if authorization.blank?

          status_code = :unauthorized

          return [status_code, { fields: { "civicrm_membership_types": "..." } }] if memberships.blank? || matching_memberships.empty?
          return [:ok, {}] if matching_memberships.any?

          [:incomplete, {}]
        end

        private

        def allowed_memberships
          options["civicrm_membership_types"].reject(&:blank?).map(&:to_i)
        end

        def memberships
          authorization.metadata["memberships"]
        end

        def matching_memberships
          (memberships) & (allowed_memberships)
        end

        def manifest
          @manifest ||= Decidim::Verifications.find_workflow_manifest(authorization&.name)
        end
      end
    end
  end
end
