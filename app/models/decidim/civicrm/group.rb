# frozen_string_literal: true

module Decidim
  module Civicrm
    class Group < ApplicationRecord
      include MarkableForDeletion

      belongs_to :organization, class_name: "Decidim::Organization", foreign_key: "decidim_organization_id"

      has_many :group_memberships, class_name: "Decidim::Civicrm::GroupMembership", dependent: :destroy
      has_many :members, class_name: "Decidim::Civicrm::Contact", source: :contact, through: :group_memberships

      validates :civicrm_group_id, uniqueness: { scope: :organization }

      def self.update_translations
        hash = { decidim: { authorization_handlers: { civicrm_group: { fields: { civicrm_groups_choices: pluck(:id, :title).to_h } } } } }

        I18n.available_locales.each do |locale|
          I18n.backend.store_translations(locale, hash)
        end

        self
      end
    end
  end
end
