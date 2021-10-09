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

      def possible_memberships
        GroupMembership.joins(:group).where({
                                              civicrm_contact_id: civicrm_contact_id,
                                              decidim_civicrm_groups: { decidim_organization_id: decidim_organization_id }
                                            })
      end
    end
  end
end
