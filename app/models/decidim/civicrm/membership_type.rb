# frozen_string_literal: true

module Decidim
  module Civicrm
    class MembershipType < ApplicationRecord
      include MarkableForDeletion

      belongs_to :organization, class_name: "Decidim::Organization", foreign_key: "decidim_organization_id"

      validates :civicrm_membership_type_id, uniqueness: { scope: :organization }

      def self.update_translations
        hash = { decidim: { authorization_handlers: { civicrm_membership: { fields: { civicrm_membership_types_choices: pluck(:id, :name).to_h } } } } }

        I18n.available_locales.each do |locale|
          I18n.backend.store_translations(locale, hash)
        end

        self
      end
    end
  end
end
