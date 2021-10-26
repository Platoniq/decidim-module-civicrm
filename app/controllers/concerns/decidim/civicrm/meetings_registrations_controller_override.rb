# frozen_string_literal: true

module Decidim
  module Civicrm
    # A command with all the business logic to create a user from omniauth
    module MeetingsRegistrationsControllerOverride
      extend ActiveSupport::Concern

      included do
        private

        def registered_in_decidim?
          Decidim::Meetings::Registration.find_by(meeting: meeting, user: current_user)
        end

        def civicrm_meeting_redirection
          Decidim::Civicrm::MeetingRedirection.find_by(meeting: meeting, active: true)&.url
        end

        def after_answer_path
          url = civicrm_meeting_redirection
          return url if url && registered_in_decidim?

          meeting_path(meeting)
        end

        def redirect_after_path
          redirect_to after_answer_path
        end
      end
    end
  end
end
