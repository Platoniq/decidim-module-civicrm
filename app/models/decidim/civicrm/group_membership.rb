# frozen_string_literal: true

module Decidim
  module Civicrm
    class GroupMembership < ApplicationRecord
      include MarkableForDeletion

      belongs_to :contact, class_name: "Decidim::Civicrm::Contact"
      belongs_to :group, class_name: "Decidim::Civicrm::Group"
    end
  end
end
