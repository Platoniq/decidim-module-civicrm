# frozen_string_literal: true

module Decidim
  module Civicrm
    class EventMeeting < ApplicationRecord
      include MarkableForDeletion

      belongs_to :meeting, foreign_key: "decidim_meeting_id", class_name: "Decidim::Meetings::Meeting", optional: true
      belongs_to :organization, foreign_key: "decidim_organization_id", class_name: "Decidim::Organization"

      has_many :event_registrations, class_name: "Decidim::Civicrm::EventRegistration", dependent: :destroy

      validates :civicrm_event_id, presence: true, unless: -> { redirect_url.present? }
      validates :civicrm_event_id, uniqueness: { scope: :organization }, allow_nil: true
      validates :meeting, presence: true, unless: -> { civicrm_event_id.present? }
      validate :same_organization
      before_destroy :abort_unless_removable

      def last_sync
        @last_sync ||= event_registrations.select(:updated_at).order(updated_at: :desc).last&.updated_at
      end

      def title
        extra["title"]
      end

      def description
        extra["description"] || summary
      end

      def summary
        extra["summary"]
      end

      def start_date
        @start_date ||= extra["start_date"].try(:to_datetime)
      end

      def end_date
        @end_date ||= extra["end_date"].try(:to_datetime)
      end

      def public?
        @public ||= extra["is_public"].present?
      end

      def active?
        @active ||= extra["is_active"].present?
      end

      # V3 API does not return the EventType, so we use the ID
      # Note (not suported here) that V4 API returns the name of the event type by using event_type_id:name
      def event_type
        @event_type ||= extra["event_type_id"]
      end

      private

      def same_organization
        return if !meeting || !organization

        errors.add(:organization, :invalid) unless organization == meeting.organization
      end

      def abort_unless_removable
        throw(:abort) if civicrm_event_id.present?
      end
    end
  end
end
