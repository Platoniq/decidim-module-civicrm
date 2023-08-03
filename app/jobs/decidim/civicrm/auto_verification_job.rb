# frozen_string_literal: true

module Decidim
  module Civicrm
    class AutoVerificationJob < ApplicationJob
      queue_as :default

      def perform(contact_id)
        @contact = Decidim::Civicrm::Contact.find_by(id: contact_id)

        unless @contact
          Rails.logger.error "AutoVerificationJob: ERROR: model not found for contact #{contact_id}"
          return
        end

        unless @contact&.user
          Rails.logger.error "AutoVerificationJob: ERROR: user relationship not found for contact #{contact_id}"
          return
        end

        perform_auth("civicrm")
        perform_auth("civicrm_groups")
        perform_auth("civicrm_membership_types")
      end

      private

      def perform_auth(name)
        handler = Decidim::AuthorizationHandler.handler_for(name, user: @contact.user)
        return unless handler

        destroy_existing!(handler)

        Decidim::Verifications::AuthorizeUser.call(handler, @contact.organization) do
          on(:ok) do
            Rails.logger.info "AutoVerificationJob: Success: created for user #{handler.user.id}"
            notify_user(handler.user, :ok, handler)
          end

          on(:invalid) do
            Rails.logger.error "AutoVerificationJob: ERROR: failed for user #{handler&.user&.id}"
            notify_user(handler.user, :invalid, handler)
          end
        end
      end

      def notify_user(user, status, handler)
        return unless Decidim::Civicrm.send_verification_notifications
        return unless handler.handler_name == "civicrm"

        notification_class = status == :ok ? Decidim::Civicrm::Verifications::SuccessNotification : Decidim::Civicrm::Verifications::InvalidNotification
        Decidim::EventsManager.publish(
          event: "decidim.events.civicrm_verification.#{status}",
          event_class: notification_class,
          resource: user,
          affected_users: [user],
          extra: {
            status: status.to_s,
            errors: handler.errors.full_messages
          }
        )
      end

      def destroy_existing!(handler)
        Decidim::Authorization.find_by(
          user: handler.user,
          name: handler.handler_name
        )&.destroy!
      end
    end
  end
end
