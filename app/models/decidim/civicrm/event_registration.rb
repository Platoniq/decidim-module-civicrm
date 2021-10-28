# frozen_string_literal: true

module Decidim
  module Civicrm
    class EventRegistration < ApplicationRecord
      include MarkableForDeletion

      belongs_to :event_meeting, class_name: "Decidim::Civicrm::EventMeeting"
      belongs_to :meeting_registration,
                 foreign_key: "decidim_meeting_registration_id",
                 class_name: "Decidim::Meetings::Registration",
                 optional: true

      validates :civicrm_event_registration_id, presence: true
      delegate :meeting, to: :event
      delegate :user, to: :meeting_registration
      delegate :contact, to: :user

      validate :same_meeting

      private

      def same_meeting
        return if !event_meeting || !meeting_registration

        errors.add(:meeting_registration, :invalid) unless meeting_registration.meeting == event_meeting.meeting
      end
    end
  end
end
