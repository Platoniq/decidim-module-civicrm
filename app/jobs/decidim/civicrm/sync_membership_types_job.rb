# frozen_string_literal: true

module Decidim
  module Civicrm
    class SyncMembershipTypesJob < ApplicationJob
      queue_as :default

      def perform(organization_id)
        MembershipType.prepare_cleanup

        api_membership_types = Decidim::Civicrm::Api::ListMembershipTypes.new.result

        Rails.logger.info "Decidim::Civicrm::SyncMembershipTypesJob: #{api_membership_types.count} membership_types to process"

        api_membership_types.each { |data| update_membership_types(organization_id, data) }

        Rails.logger.info "Decidim::Civicrm::SyncMembershipTypesJob: #{MembershipType.to_delete.count} membership_types to delete"

        MembershipType.clean_up_records
      end

      def update_membership_types(organization_id, data)
        civicrm_membership_type_id = data[:id]

        return if civicrm_membership_type_id.blank?

        Rails.logger.info "Decidim::Civicrm::SyncMembershipTypesJob: Creating / updating MembershipType #{data[:name]} (civicrm id: #{civicrm_membership_type_id}) with data #{data}"

        membership_type = MembershipType.find_or_initialize_by(decidim_organization_id: organization_id, civicrm_membership_type_id: civicrm_membership_type_id)

        membership_type.name = data[:name]
        membership_type.marked_for_deletion = false

        membership_type.save!
      end
    end
  end
end
