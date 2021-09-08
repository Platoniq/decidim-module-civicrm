# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class FindUser < BaseQuery
        def initialize(id, query = nil)
          @request = Request.new(
            entity: "User",
            id: id,
            json: json_params(query || default_query)
          )

          store_result
        end

        def default_query
          {
            "api.Contact.get" => {
              "return" => "display_name"
            }
          }
        end

        private

        def parsed_response
          user = response["values"].first
          contact = user.delete("api.Contact.get")["values"].first

          {
            user: user,
            contact: contact
          }
        end
      end
    end
  end
end
