# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class ContactsInGroup < BaseQuery
        def initialize(id)
          request = Request.new(
            entity: "Contact",
            group: id,
            json: json_params(query)
          )

          @result = parse(request.response).deep_symbolize_keys if success?
        end

        def self.query
          {
            options: { limit: 0 },
            return: "contact_id"
          }
        end

        private

        def parse(response)
          {
            contact_ids: response["values"].map { |v| v["contact_id"] }
          }
        end
      end
    end
  end
end
