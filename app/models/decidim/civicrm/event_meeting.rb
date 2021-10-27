# frozen_string_literal: true

module Decidim
  module Civicrm
    class EventMeeting < ApplicationRecord
      include MarkableForDeletion

      belongs_to :meeting, foreign_key: "decidim_meeting_id", class_name: "Decidim::Meetings::Meeting"
      belongs_to :organization, foreign_key: "decidim_organization_id", class_name: "Decidim::Organization"

      has_many :event_registrations, class_name: "Decidim::Civicrm::EventRegistration", dependent: :destroy

      validate :same_organization
      before_destroy :abort_unless_removable

      def last_sync
        @last_sync ||= event_registrations.select(:updated_at).order(updated_at: :desc).last&.updated_at
      end

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
