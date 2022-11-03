# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class ListEvents < Base::ListQuery
        def initialize(query = nil)
          @request = Base::Request.get(
            entity: "Event",
            is_active: 1,
            json: json_params(query || default_query)
          )

          store_result
        end

        def default_query
          {
            return: "event_id,title,event_title,event_type,start_date,evet_start_date,end_date,event_end_date"
          }
        end

        def self.parse_item(item)
          FindEvent.parse_item(item)
        end
      end
    end
  end
end
