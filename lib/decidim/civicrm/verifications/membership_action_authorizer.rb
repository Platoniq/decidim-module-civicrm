# frozen_string_literal: true

module Decidim
  module Civicrm
    module Verifications
      class MembershipActionAuthorizer < Decidim::Verifications::DefaultActionAuthorizer
        def authorize
          membership_type_ids = options["civicrm_membership_types"].reject { |o| o.blank? }.map(&:to_i)

          status_code = has_membership?(membership_type_ids) ? :ok : :unauthorized

          [status_code, {}]
        end

        def has_membership?(membership_type_ids)
          return unless membership_type_ids.any?

          matching_groups = authorization.metadata["memberships"] & (membership_type_ids)
          matching_groups.any?
        end

        def manifest
          @manifest ||= Decidim::Verifications.find_workflow_manifest(authorization&.name)
        end
      end
    end
  end
end
