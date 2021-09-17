# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class FindContact < Base::FindQuery
        def initialize(id, query = nil)
          raise Civicrm::Error, "Must provide a valid id for FindContact" if id.blank?

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

        def self.parse_item(item)
          contact = {
            id: item["id"].to_i,
            display_name: item["display_name"]
          }

          memberships = item["api.Membership.get"]["values"]

          {
            contact: contact,
            memberships: memberships.map { |m| ListContactMemberships.parse_item(m) }
          }
        end
      end
    end
  end
end
