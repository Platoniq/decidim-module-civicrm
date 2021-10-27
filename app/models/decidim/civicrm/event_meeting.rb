# frozen_string_literal: true

module Decidim
  module Civicrm
    class EventMeeting < ApplicationRecord
      belongs_to :meeting, foreign_key: "decidim_meeting_id", class_name: "Decidim::Meetings::Meeting"
      belongs_to :organization, foreign_key: "decidim_organization_id", class_name: "Decidim::Organization"

      validate :same_organization
      before_destroy :abort_unless_removable

      private

      def same_organization
        return if !meeting || !organization

        errors.add(:organization, :invalid) unless organization == meeting.organization
      end

      def abort_unless_removable
        throw(:abort) unless removable?
      end
    end
  end
end
