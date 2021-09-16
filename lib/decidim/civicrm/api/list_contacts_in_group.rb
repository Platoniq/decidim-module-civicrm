# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class ListContactsInGroup < Base::ListQuery
        def initialize(id, query = nil)
          @request = Base::Request.new(
            entity: "Contact",
            group: id,
            json: json_params(query || default_query)
          )

          store_result
        end

        def default_query
          {
            return: "contact_id"
          }
        end

        private

        def parse_item(item)
          item["contact_id"].to_i
        end
      end
    end
  end
end
