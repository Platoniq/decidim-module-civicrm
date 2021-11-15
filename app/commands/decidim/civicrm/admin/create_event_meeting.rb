# frozen_string_literal: true

module Decidim
  module Civicrm
    module Admin
      # A command with all the business logic for when a user starts following a resource.
      class CreateEventMeeting < Rectify::Command
        # Public: Initializes the command.
        #
        # form         - A form object with the params.
        # current_user - The current user.
        def initialize(form)
          @form = form
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid, together with the follow.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          create_event_meeting!

          broadcast(:ok)
        end

        private

        attr_reader :form

        def create_event_meeting!
          EventMeeting.create!(
            decidim_meeting_id: form.meeting.id,
            civicrm_event_id: form.civicrm_event_id,
            decidim_organization_id: form.meeting.organization.id,
            redirect_url: form.redirect_url,
            redirect_active: form.redirect_active
          )
        end
      end
    end
  end
end
