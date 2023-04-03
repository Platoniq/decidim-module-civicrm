# frozen_string_literal: true

module Decidim
  module Civicrm
    class JoinContactToParticipatorySpacesJob < ApplicationJob
      queue_as :default

      def perform(contact_id)
        @contact = Decidim::Civicrm::Contact.find_by(id: contact_id)

        unless @contact
          Rails.logger.error "JoinContactToParticipatorySpacesJob: ERROR: model not found for contact #{contact_id}"
          return
        end

        @contact.groups.each do |group|
          group.group_participatory_spaces.each do |item|
            next unless (space = item.participatory_space)
            next unless space.respond_to?(:participatory_space_private_users)

            # TODO: use CreateParticipatorySpacePrivateUser to notify users if enabled by config var
            Decidim::ParticipatorySpacePrivateUser.find_or_create_by(decidim_user_id: @contact.decidim_user_id, privatable_to: space)
          end
        end
      end
    end
  end
end
