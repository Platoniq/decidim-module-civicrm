# frozen_string_literal: true

module Decidim
  module Civicrm
    class Contact < ApplicationRecord
      include MarkableForDeletion

      belongs_to :decidim_user, class_name: "Decidim::User"

      has_many :group_memberships, class_name: "Decidim::Civicrm::GroupMembership", dependent: :destroy
      has_many :groups, class_name: "Decidim::Civicrm::Group", through: :group_memberships
    end
  end
end
