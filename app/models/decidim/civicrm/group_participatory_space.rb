# frozen_string_literal: true

module Decidim
  module Civicrm
    class GroupParticipatorySpace < ApplicationRecord
      belongs_to :group, class_name: "Decidim::Civicrm::Group"

      belongs_to :participatory_space, foreign_type: "participatory_space_type", polymorphic: true

      validate :group_and_participatory_space_same_organization

      private

      # Private: check if the participatory space and the participatory_space have the same organization
      def group_and_participatory_space_same_organization
        return if !group || !participatory_space

        errors.add(:group, :invalid) unless participatory_space.organization == group.organization
      end
    end
  end
end
