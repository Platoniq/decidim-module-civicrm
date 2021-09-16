# frozen_string_literal: true

module Decidim
  module Civicrm
    class Contact < ApplicationRecord
      include MarkableForDeletion

      belongs_to :organization, class_name: "Decidim::Organization", foreign_key: "decidim_organization_id"

      belongs_to :user, class_name: "Decidim::User", foreign_key: "decidim_user_id"

      has_many :group_memberships, class_name: "Decidim::Civicrm::GroupMembership", dependent: :destroy
      has_many :groups, class_name: "Decidim::Civicrm::Group", through: :group_memberships

      validates :user, uniqueness: true
      validates :civicrm_contact_id, uniqueness: { scope: :organization }
    end
  end
end
