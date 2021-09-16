# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class ListGroups < Base::ListQuery
        def initialize(query = nil)
          @request = Base::Request.new(
            entity: "Group",
            is_active: 1,
            json: json_params(query || default_query)
          )

          store_result
        end

        def default_query
          {
            return: "group_id,name,title,description,group_type"
          }
        end

        private

        def parse_item(item)
          {
            id: item["id"].to_i,
            name: item["name"],
            title: item["title"],
            description: item["description"],
            group_type: item["group_type"].map(&:to_i)
          }
        end
      end
    end
  end
end
