# frozen_string_literal: true

module Decidim
  module Civicrm
    module Verifications
      class MembershipTypesActionAuthorizer < Decidim::Verifications::DefaultActionAuthorizer
        def authorize
          return [:missing, { action: :authorize }] if authorization.blank?

          status_code = :unauthorized

          return [status_code, { fields: { membership_types: "..." } }] if authorization_membership_types.blank?
          return [:ok, {}] if belongs_to_membership_type?

          [status_code, {}]
        end

        private

        def authorization_membership_types
          authorization.metadata["membership_type_ids"] || []
        end

        def belongs_to_membership_type?
          options["membership_types"]&.split(",")&.detect do |membership_type|
            authorization_membership_types.include? membership_type.to_i
          end
        end

        def manifest
          @manifest ||= Decidim::Verifications.find_workflow_manifest(authorization&.name)
        end
      end
    end
  end
end
