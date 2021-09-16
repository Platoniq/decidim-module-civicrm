# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class FindContact < Base::BaseQuery
        def initialize(id, query = nil)
          @request = Base::Request.new(
            entity: "Contact",
            contact_id: id,
            json: json_params(query || default_query)
          )

          store_result
        end

        def default_query
          {
            return: "display_name",
            "api.Membership.get" => {
              return: "membership_type_id"
            }
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
