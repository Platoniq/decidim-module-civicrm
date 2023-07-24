# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class ListGroups < Base::ListQuery
        def initialize(query = nil)
          @request = Base::Request.get(
            {
              entity: "Group",
              is_active: 1,
              json: json_params(query || default_query)
            }
          )

          store_result
        end

        def default_query
          {
            return: "group_id,name,title,description,group_type"
          }
        end

        def self.parse_item(item)
          FindGroup.parse_item(item)
        end
      end
    end
  end
end
