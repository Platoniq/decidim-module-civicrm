# frozen_string_literal: true

module Decidim
  module Civicrm
    class SyncGroupsJob < ApplicationJob
      queue_as :default

      def perform
        Group.prepare_cleanup

        api_groups = Decidim::Civicrm::Api::ListGroups.new.result
        api_groups.each { |data| update_group(group, data) }

        Group.clean_up_records
      end

      def update_group(data)
        Group.find_or_create_by(civicrm_group_id: data[:id]) do |group|
          group.update!(
            title: data[:title],
            description: data[:description],
            extra: data,
            marked_for_deletion: false
          )

          update_group_memberships(data[:id])
        end
      end

      def update_group_memberships(id)
        GroupMemebership.prepare_cleanup

        api_contacts_in_group = Decidim::Civicrm::Api::ContactsInGroup.new(id).result
        api_contacts_in_group.each { |data| update_group_membership(data) }

        GroupMemebership.clean_up_records
      end

      def update_group_membership(id, data)
        GroupMemebership.find_or_create_by(civicrm_group_id: id, civicrm_contact_id: data[:id]) do |group_membership|
          group_membership.update!(marked_for_deletion: false)
        end
      end
    end
  end
end
