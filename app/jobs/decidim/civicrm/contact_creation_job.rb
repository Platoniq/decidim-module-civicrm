# frozen_string_literal: true

module Decidim
  module Civicrm
    class ContactCreationJob < ApplicationJob
      queue_as :default

      def perform(data)
        data = JSON.parse(data).deep_symbolize_keys

        user = Decidim::User.find(data[:user_id])

        return unless user.civicrm_identity?

        Decidim::Civicrm::CreateContact.call(contact_form(user, data))
      end

      private

      def contact_form(user, data)
        @contact_form ||= Decidim::Civicrm::ContactForm.from_params({
                                                                      decidim_user_id: user.id,
                                                                      decidim_organization_id: user.organization.id,
                                                                      civicrm_contact_id: data[:raw_data][:extra][:contact][:contact_id],
                                                                      extra: data[:raw_data][:extra][:contact]
                                                                    })
      end
    end
  end
end
