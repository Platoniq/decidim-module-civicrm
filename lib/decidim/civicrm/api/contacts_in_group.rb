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
            options: { limit: 10 }, # DEBUG
            return: "contact_id"
          }
        end

        private

        def parsed_response
          {
            contact_ids: response["values"].map { |v| v["contact_id"] }
          }
        end
      end
    end
  end
end
