# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class ListGroups < BaseQuery
        def initialize(query = nil)
          @request = Request.new(
            entity: "Group",
            is_active: 1,
            json: json_params(query || default_query)
          )

          store_result
        end

        def default_query
          {
            options: { limit: 0 },
            return: "group_id,name,title,description,group_type"
          }
        end

        private

        def parsed_response
          {
            groups: response["values"]
          }
        end
      end
    end
  end
end
