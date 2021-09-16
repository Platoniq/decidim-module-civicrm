# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class ListContactMemberships < BaseQuery
        def initialize(id, query = nil)
          @request = Request.new(
            entity: "Membership",
            contact_id: id,
            json: json_params(query || default_query)
          )

          store_result
        end

        def default_query
          {
            options: { limit: 0 },
            return: "membership_type_id"
          }
        end

        private

        def parsed_response
          {
            membership_type_ids: response["values"].map { |v| v["membership_type_id"] }
          }
        end
      end
    end
  end
end
