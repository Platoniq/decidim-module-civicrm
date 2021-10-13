# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class ListMembershipTypes < BaseQuery
        def initialize(id, query = nil)
          @request = Request.get(
            entity: "MembershipType",
            contact_id: id,
            json: json_params(query || default_query)
          )

          store_result
        end

        def default_query
          {
            options: { limit: 0 },
            return: "name"
          }
        end

        private

        def parsed_response
          {
            membership_types: response["values"]
          }
        end
      end
    end
  end
end
