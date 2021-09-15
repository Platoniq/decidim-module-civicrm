# frozen_string_literal: true

module Decidim
  module Civicrm
    class SyncGroupJob < ApplicationJob
      queue_as :default

      def perform(group_id)
        GroupMembership.prepare_cleanup(group_id: group_id)

        group = Decidim::Civicrm::Group.find(group_id)

        data = Decidim::Civicrm::Api::FindGroup.new(group.civicrm_group_id).result[:group]

        Rails.logger.info "Decidim::Civicrm::SyncGroupJob: Process group #{group.title} (civicrm id: #{group.civicrm_group_id})"

        update_group(group, data)

        Rails.logger.info "Decidim::Civicrm::SyncGroupJob: #{GroupMembership.where(group_id: group_id).to_delete.count} group memberships to delete"

        GroupMembership.clean_up_records(group_id: group_id)
      end

      def update_group(group, data)
        Rails.logger.info "Decidim::Civicrm::SyncGroupJob: Creating / updating Group #{group.title} (civicrm id: #{group.civicrm_group_id}) with data #{data}"

        group.update!(
          title: data[:title],
          description: data[:description],
          extra: data,
          marked_for_deletion: false
        )

        update_group_memberships(group)
      end

      def update_group_memberships(group)
        Rails.logger.info "Decidim::Civicrm::SyncGroupJob: Updating group memberships for Group #{group.title} (civicrm id: #{group.civicrm_group_id})"

        api_contacts_in_group = Decidim::Civicrm::Api::ContactsInGroup.new(group.civicrm_group_id).result[:contact_ids]

        group.update!(civicrm_member_count: api_contacts_in_group.count)

        Contact.where(organization: group.organization, civicrm_contact_id: api_contacts_in_group).find_each do |contact|
          update_group_membership(group, contact)
        end
      end

      def update_group_membership(group, contact)
        return unless group && contact

        Rails.logger.info "Decidim::Civicrm::SyncGroupJob: Creating / updating membership for Contact #{contact.civicrm_contact_id} for Group with civicrm id: #{civicrm_group_id}"

        GroupMembership.find_or_create_by(organization: group.organization, contact: contact, group: group) do |group_membership|
          group_membership.update!(marked_for_deletion: false)
        end
      end
    end
  end
end
