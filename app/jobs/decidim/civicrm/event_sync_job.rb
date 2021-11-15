# frozen_string_literal: true

module Decidim
  module Civicrm
    class EventSyncJob < ApplicationJob
      queue_as :default

      attr_reader :result, :parser

      def perform(event_name, data)
        @parser = case event_name
                  when "decidim.events.meetings.meeting_created"
                    EventParsers::EventMeetingParser.new(data[:resource])
                  when "decidim.events.meetings.meeting_registration_confirmed"
                    EventParsers::EventRegistrationParser.new(Decidim::Meetings::Registration.find_by(user: data[:affected_users]&.first, meeting: data[:resource]))
                  end

        return unless @parser

        unless @parser.valid?
          Rails.logger.error "Parser invalid. Not publishing event ##{data[:resource].id} [#{event_name}] to CiviCRM API: #{@parser.errors.values}"
          return
        end

        if publish
          Rails.logger.info "Published event ##{data[:resource].id} [#{event_name}] with CiviCRM UID #{@result["id"]}"
          begin
            @parser.result = @result
            @parser.save!
          rescue StandardError => e
            Rails.logger.error "Error saving model ##{data[:resource].id} with CiviCRM UID #{@result["id"]} [#{e.message}]"
          end
        else
          Rails.logger.error "Error publishing event ##{data[:resource].id} [#{event_name}] to CiviCRM API #{@result}"
        end
      end

      private

      def publish
        request = Decidim::Civicrm::Api::Request.post(@parser.data)
        @result = request.response
        @result["is_error"] == 1 ? nil : @result
      rescue StandardError => e
        @result["exception"] = e.message
        nil
      end
    end
  end
end
