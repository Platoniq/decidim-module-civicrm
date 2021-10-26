# frozen_string_literal: true

module Decidim
  module Civicrm
    module Admin
      class MeetingRedirectionForm < Decidim::Form
        attribute :decidim_meeting_id, Integer
        attribute :url, String
        attribute :active, Boolean
        validates :decidim_meeting_id, :url, presence: true

        def meeting
          @meeting ||= Decidim::Meetings::Meeting.find(decidim_meeting_id)
        end
      end
    end
  end
end
