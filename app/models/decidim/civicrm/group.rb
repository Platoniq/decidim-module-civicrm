# frozen_string_literal: true

module Decidim
  module Civicrm
    class Group < ApplicationRecord
      include MarkableForDeletion

      belongs_to :organization, class_name: "Decidim::Organization", foreign_key: "decidim_organization_id"

      has_many :group_memberships, class_name: "Decidim::Civicrm::GroupMembership", dependent: :destroy
      has_many :members, class_name: "Decidim::Civicrm::Contact", source: :contact, through: :group_memberships

      validates :civicrm_group_id, uniqueness: { scope: :organization }

      def last_sync
        @last_sync ||= group_memberships.select(:updated_at).order(updated_at: :desc).last&.updated_at
      end
    end
  end
end
