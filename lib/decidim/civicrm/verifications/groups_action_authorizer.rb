# frozen_string_literal: true

module Decidim
  module Civicrm
    module Verifications
      class GroupsActionAuthorizer < Decidim::Verifications::DefaultActionAuthorizer
        def authorize
          return [:missing, { action: :authorize }] if authorization.blank?

          status_code = :unauthorized

          return [status_code, { fields: { groups: "..." } }] if authorization_groups.blank?
          return [:ok, {}] if belongs_to_group?

          [status_code, {}]
        end

        private

        def authorization_groups
          authorization.metadata["group_ids"] || []
        end

        def belongs_to_group?
          options["groups"]&.split(",")&.detect do |group|
            authorization_groups.include? group.to_i
          end
        end

        def manifest
          @manifest ||= Decidim::Verifications.find_workflow_manifest(authorization&.name)
        end
      end
    end
  end
end
