# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class FindEvent < Base::FindQuery
        def initialize(id, query = nil)
          @request = Base::Request.get(
            {
              entity: "Event",
              id: id,
              json: json_params(query || default_query)
            }
          )

          store_result
        end

        def default_query
          {
            return: "event_id,title,event_title,event_type,start_date,evet_start_date,end_date,event_end_date"
          }
        end

        private

        def parsed_response
          {
            event: response["values"].first
          }
        end
      end
    end
  end
end
