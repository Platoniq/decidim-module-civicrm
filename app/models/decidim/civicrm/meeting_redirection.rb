# frozen_string_literal: true

module Decidim
  module Civicrm
    class MeetingRedirection < ApplicationRecord
      belongs_to :meeting, foreign_key: "decidim_meeting_id", class_name: "Decidim::Meetings::Meeting"
      belongs_to :organization, foreign_key: "decidim_organization_id", class_name: "Decidim::Organization"

      validate :same_organization

      private

      def same_organization
        return if !meeting || !organization

        errors.add(:organization, :invalid) unless organization == meeting.organization
      end
    end
  end
end
