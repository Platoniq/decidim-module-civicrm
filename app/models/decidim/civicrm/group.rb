# frozen_string_literal: true

module Decidim
  module Civicrm
    class Group < ApplicationRecord
      include MarkableForDeletion

      has_many :group_memberships, class_name: "Decidim::Civicrm::GroupMemebership", foreign_key: "civicrm_group_id", dependent: :destroy
      has_many :contacts, class_name: "Decidim::Civicrm::Contact", through: :group_memberships
    end
  end
end
