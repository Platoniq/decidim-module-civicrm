# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class ListMembershipTypes < Base::ListQuery
        def initialize(query = nil)
          @request = Base::Request.new(
            entity: "MembershipType",
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

        def self.parse_item(item)
          {
            id: item["id"].to_i,
            name: item["name"]
          }
        end
      end
    end
  end
end
