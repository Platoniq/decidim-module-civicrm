# frozen_string_literal: true

module Decidim
  module Civicrm
    module Admin
      class EventMeetingForm < Decidim::Form
        attribute :decidim_meeting_id, Integer
        attribute :redirect_url, String
        attribute :redirect_active, Boolean
        validates :decidim_meeting_id, :redirect_url, presence: true

        def meeting
          @meeting ||= Decidim::Meetings::Meeting.find(decidim_meeting_id)
        end
      end
    end
  end
end
