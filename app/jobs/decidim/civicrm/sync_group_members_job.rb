# frozen_string_literal: true

module Decidim
  module Civicrm
    class SyncGroupMembersJob < ApplicationJob
      queue_as :default

      def perform(group_id)
        GroupMembership.prepare_cleanup(group_id: group_id)

        group = Decidim::Civicrm::Group.find(group_id)

        data = Decidim::Civicrm::Api::FindGroup.new(group.civicrm_group_id).result[:group]

        Rails.logger.info "SyncGroupMembersJob: Process group #{group.title} (civicrm id: #{group.civicrm_group_id})"

        update_group(group, data)

        Rails.logger.info "SyncGroupMembersJob: #{GroupMembership.where(group_id: group_id).to_delete.count} group memberships to delete"

        GroupMembership.clean_up_records(group_id: group_id)

        ActiveSupport::Notifications.publish("decidim.civicrm.group_membership.updated", group.id)
      end

      def update_group(group, data)
        Rails.logger.info "SyncGroupMembersJob: Creating / updating Group #{group.title} (civicrm id: #{group.civicrm_group_id}) with data #{data}"

        group.update!(
          title: data[:title],
          description: data[:description],
          extra: data,
          marked_for_deletion: false
        )

        update_group_memberships(group)
      end

      def update_group_memberships(group)
        Rails.logger.info "SyncGroupMembersJob: Updating group memberships for Group #{group.title} (civicrm id: #{group.civicrm_group_id})"

        api_memberships_in_group = Decidim::Civicrm::Api::ContactsInGroup.new(group.civicrm_group_id).result

        group.update!(civicrm_member_count: api_memberships_in_group.count)

        api_memberships_in_group.each do |member|
          update_group_membership(group, member)
        end
      end

      def update_group_membership(group, member)
        return unless group && member

        Rails.logger.info "SyncGroupMembersJob: Creating / updating membership for Contact #{member[:contact_id]} for Group with civicrm id: #{group.civicrm_group_id}"

        membership = GroupMembership.find_or_create_by(civicrm_contact_id: member[:contact_id], group: group)
        membership.contact = Decidim::Civicrm::Contact.find_by(civicrm_contact_id: member[:contact_id], organization: group.organization)
        membership.extra = member
        membership.marked_for_deletion = false

        membership.save!
      end
    end
  end
end
