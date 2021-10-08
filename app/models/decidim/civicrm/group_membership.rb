# frozen_string_literal: true

module Decidim
  module Civicrm
    class GroupMembership < ApplicationRecord
      include MarkableForDeletion

      belongs_to :contact, class_name: "Decidim::Civicrm::Contact", optional: true
      belongs_to :group, class_name: "Decidim::Civicrm::Group"

      validates :contact, uniqueness: { scope: [:group] }, if: -> { contact.present? }
      validates :civicrm_contact_id, uniqueness: { scope: [:group] }

      delegate :organization, to: :group
      delegate :user, to: :contact

      def synchronized?
        contact.present?
      end

      def name
        contact&.user&.name || extra["display_name"] || civicrm_contact_id
      end

      def email
        contact&.user&.email || extra["email"]
      end
    end
  end
end
