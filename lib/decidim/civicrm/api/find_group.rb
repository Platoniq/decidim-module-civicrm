# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class FindGroup < Base::BaseQuery
        def initialize(id, query = nil)
          @request = Base::Request.new(
            entity: "Group",
            group_id: id,
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

        def parsed_response
          response["values"].first
        end
      end
    end
  end
end
