# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class ListGroups < BaseQuery
        def initialize(id)
          request = Request.new(
            entity: "Group",
            id: id,
            is_active: 1,
            json: json_params(query)
          )

          @result = parse(request.response).deep_symbolize_keys if success?
        end

        def self.query
          {
            options: { limit: 0 },
            return: "group_id,name,title,description,group_type"
          }
        end

        private

        def parse(response)
          {
            groups: response["values"]
          }
        end
      end
    end
  end
end
