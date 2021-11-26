# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class ParticipantsInEvent < Base::ListQuery
        def initialize(id, query = nil)
          @request = Base::Request.get(
            entity: "Participant",
            event_id: id,
            json: json_params(query || default_query)
          )

          store_result
        end

        def default_query
          {
            options: { limit: 0 },
            return: "contact_id,display_name,participant_status,id,participant_fee_amount,participant_fee_level,participant_fee_currency"
          }
        end

        private

        def parsed_response
          response["values"]
        end
      end
    end
  end
end
