# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class ListContactGroups < Base::ListQuery
        def initialize(id, query = nil)
          @request = Base::Request.new(
            entity: "GroupContact",
            contact_id: id,
            json: json_params(query || default_query)
          )

          store_result
        end

        def default_query
          {
            return: "group_id"
          }
        end

        def self.parse_item(item)
          item["group_id"].to_i
        end
      end
    end
  end
end
