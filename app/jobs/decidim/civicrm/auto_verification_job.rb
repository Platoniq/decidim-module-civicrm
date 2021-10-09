# frozen_string_literal: true

module Decidim
  module Civicrm
    class AutoVerificationJob < ApplicationJob
      queue_as :default

      def perform(contact_id)
        @contact = Decidim::Civicrm::Contact.find_by(id: contact_id)

        unless @contact
          Rails.logger.error "ERROR: Civicrm Authorization model not found for contact #{contact_id}"
          return
        end

        unless @contact&.user
          Rails.logger.error "ERROR: Civicrm Authorization user relationship not found for contact #{contact_id}"
          return
        end

        perform_civicrm_auth
        perform_groups_auth
      end

      private

      def perform_civicrm_auth
        handler = Decidim::AuthorizationHandler.handler_for("civicrm", user: @contact.user)
        return unless handler

        Decidim::Verifications::AuthorizeUser.call(handler) do
          on(:ok) do
            Rails.logger.info "Success: Civicrm Authorization created for user #{handler.user.id}"
            notify_user(handler.user, :ok, handler) if Decidim::Civicrm.send_verification_notifications
          end

          on(:invalid) do
            Rails.logger.error "ERROR: Civicrm Authorization failed for user #{handler&.user&.id}"
            notify_user(handler.user, :invalild, handler) if Decidim::Civicrm.send_verification_notifications
          end
        end
      end

      def perform_groups_auth
        handler = Decidim::AuthorizationHandler.handler_for("civicrm_groups", user: @contact.user)
        return unless handler

        Decidim::Verifications::AuthorizeUser.call(handler) do
          on(:ok) do
            Rails.logger.info "Success: Civicrm Groups Authorization created for user #{handler.user.id}"
          end

          on(:invalid) do
            Rails.logger.error "ERROR: Civicrm Groups Authorization failed for user #{handler&.user&.id}"
          end
        end
      end

      def notify_user(user, status, handler)
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
    end
  end
end
