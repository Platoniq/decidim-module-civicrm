# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class ContactsInGroup < BaseQuery
        def initialize(id, query = nil)
          @request = Request.new(
            entity: "Contact",
            group: id,
            json: json_params(query || default_query)
          )

          store_result
        end

        def default_query
          {
            options: { limit: 0 },
            return: "contact_id,display_name,email"
          }
        end

        private

        def parsed_response
          response["values"]
        end
      end
    end
  end
end
