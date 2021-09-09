# frozen_string_literal: true

module Decidim
  module Civicrm
    class GroupMemebership < ApplicationRecord
      include MarkableForDeletion

      belongs_to :contact, class_name: "Decidim::Civicrm::Contact", foreign_key: "civicrm_contact_id"
      belongs_to :group, class_name: "Decidim::Civicrm::Group", foreign_key: "civicrm_group_id"
    end
  end
end
