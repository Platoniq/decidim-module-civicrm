# frozen_string_literal: true

module Decidim
  module Civicrm
    class CreateContact < Rectify::Command
      # Public: Initializes the command.
      #
      # form - A contact form
      def initialize(form)
        @form = form
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if we couldn't proceed.
      #
      # Returns nothing.
      def call
        return broadcast(:invalid) if form.invalid?

        begin
          @contact = Contact.create!(
            decidim_organization_id: form.decidim_organization_id,
            decidim_user_id: form.decidim_user_id,
            civicrm_contact_id: form.civicrm_contact_id,
            extra: form.extra
          )
          broadcast(:ok, @contact)
        rescue ActiveRecord::RecordNotUnique
          broadcast(:invalid, I18n.t("decidim.civicrm.contact.errors.not_unique"))
        rescue StandardError => e
          broadcast(:invalid, e.message)
        end
      end

      private

      attr_reader :form, :contact
    end
  end
end
