# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class ListContactsInGroup < Base::ListQuery
        def initialize(id, query = nil)
          @request = Base::Request.get(
            entity: "Contact",
            group: id,
            json: json_params(query || default_query)
          )

          store_result
        end

        def default_query
          {
            return: "contact_id,display_name"
          }
        end

        def self.parse_item(item)
          {
            contact_id: item["contact_id"].to_i,
            display_name: item["display_name"]
          }
        end
      end
    end
  end
end
