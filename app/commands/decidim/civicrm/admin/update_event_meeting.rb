# frozen_string_literal: true

module Decidim
  module Civicrm
    module Admin
      # A command with all the business logic for when a user starts following a resource.
      class UpdateEventMeeting < Decidim::Command
        # Public: Initializes the command.
        #
        # form         - A form object with the params.
        # current_user - The current user.
        def initialize(form, event_meeting)
          @form = form
          @event_meeting = event_meeting
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid, together with the follow.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          udpate_event_meeting!

          broadcast(:ok)
        end

        private

        attr_reader :form, :event_meeting

        def udpate_event_meeting!
          event_meeting.redirect_url = form.redirect_url
          event_meeting.redirect_active = form.redirect_active
          event_meeting.civicrm_event_id = form.civicrm_event_id || event_meeting.civicrm_event_id
          event_meeting.save!
        end
      end
    end
  end
end
