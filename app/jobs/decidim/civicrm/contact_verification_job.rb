# frozen_string_literal: true

module Decidim
  module Civicrm
    class ContactVerificationJob < ApplicationJob
      queue_as :default

      def perform(data)
        contact = Decidim::Civicrm::Contact.find(data[:contact_id])

        handler = retrieve_handler(contact.user)

        Decidim::Verifications::AuthorizeUser.call(handler) do
          on(:ok) do
            notify_user(handler.user, :ok, handler)
          end

          on(:invalid) do
            notify_user(handler.user, :invalid, handler)
          end
        end
      end

      private

      # Retrieves handler from Verification workflows registry.
      def retrieve_handler(user)
        Decidim::AuthorizationHandler.handler_for("civicrm", user: user)
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
