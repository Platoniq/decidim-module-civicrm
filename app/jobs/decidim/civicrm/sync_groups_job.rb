# frozen_string_literal: true

module Decidim
  module Civicrm
    class SyncGroupsJob < ApplicationJob
      queue_as :default

      def perform(organization_id)
        Group.prepare_cleanup
        GroupMembership.prepare_cleanup

        api_groups = Decidim::Civicrm::Api::ListGroups.new.result[:groups]

        Rails.logger.info "Decidim::Civicrm::SyncGroupsJob: #{api_groups.count} groups to process"

        api_groups.each { |data| update_group(organization_id, data) }

        Rails.logger.info "Decidim::Civicrm::SyncGroupsJob: #{Group.to_delete.count} groups to delete"
        Rails.logger.info "Decidim::Civicrm::SyncGroupsJob: #{GroupMembership.to_delete.count} group memberships to delete"

        Group.clean_up_records
        GroupMembership.clean_up_records
      end

      def update_group(organization_id, data)
        civicrm_group_id = data[:id]

        return if civicrm_group_id.blank?

        Rails.logger.info "Decidim::Civicrm::SyncGroupsJob: Creating or updating Group #{data[:title]} (#{civicrm_group_id}) with data #{data}"

        group = Group.find_or_initialize_by(decidim_organization_id: organization_id, civicrm_group_id: civicrm_group_id)

        group.title = data[:title]
        group.description = data[:description]
        group.extra = data
        group.marked_for_deletion = false

        group.save!

        update_group_memberships(organization_id, group)
      end

      def update_group_memberships(organization_id, group)
        Rails.logger.info "Decidim::Civicrm::SyncGroupsJob: Updating group memberships for Group #{group.title} (#{group.civicrm_group_id})"

        api_contacts_in_group = Decidim::Civicrm::Api::ContactsInGroup.new(group.civicrm_group_id).result[:contact_ids]

        Contact.where(decidim_organization_id: organization_id, civicrm_contact_id: api_contacts_in_group).find_each do |contact|
          update_group_membership(organization_id, group.civicrm_group_id, contact)
        end
      end

      def update_group_membership(organization_id, civicrm_group_id, contact)
        return unless contact && (group = Group.find_by(decidim_organization_id: organization_id, civicrm_group_id: civicrm_group_id))

        Rails.logger.info "Decidim::Civicrm::SyncGroupsJob: Creating or updating membership for Contact #{contact.civicrm_contact_id} for Group #{civicrm_group_id}"

        GroupMembership.find_or_create_by(decidim_organization_id: organization_id, contact: contact, group: group) do |group_membership|
          group_membership.update!(marked_for_deletion: false)
        end
      end
    end
  end
end
