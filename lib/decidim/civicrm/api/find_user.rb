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
              return: "display_name"
            },
            "api.Membership.get": {
              contact_id: "$value.contact_id",
              return: "membership_type_id"
            }
          }
        end

        private

        def parsed_response
          user = response["values"].first
          contact = user.delete("api.Contact.get")["values"].first
          memberships = user.delete("api.Membership.get")["values"]

          {
            user: user,
            contact: contact,
            memberships: memberships
          }
        end
      end
    end
  end
end
