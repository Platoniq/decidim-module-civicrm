# frozen_string_literal: true

module Decidim
  module Civicrm
    class CreateContactJob < ApplicationJob
      queue_as :default

      def perform(data)
        data = JSON.parse(data)

        user = Decidim::User.find(data[:user_id])

        return unless user.civicrm_identity?

        Contact.create!(
          user: user,
          civicrm_contact_id: data[:contact_id],
          extra: data
        )
      end
    end
  end
end
