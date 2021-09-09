# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class FindContact < BaseQuery
        def initialize(id, query = nil)
          @request = Request.new(
            entity: "Contact",
            contact_id: id,
            json: json_params(query || default_query)
          )

          store_result
        end

        def default_query
          {
            "return" => "display_name"
          }
        end

        private

        def parsed_response
          {
            contact: response["values"].first
          }
        end
      end
    end
  end
end
