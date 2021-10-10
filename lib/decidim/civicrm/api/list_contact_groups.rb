# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class ListContactGroups < BaseQuery
        def initialize(id, query = nil)
          @request = Request.get(
            entity: "GroupContact",
            contact_id: id,
            json: json_params(query || default_query)
          )

          store_result
        end

        def default_query
          {
            options: { limit: 0 },
            return: "group_id"
          }
        end

        private

        def parsed_response
          {
            group_ids: response["values"].map { |v| v["group_id"] }
          }
        end
      end
    end
  end
end
