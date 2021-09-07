# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class FindUser < BaseQuery
        def initialize(id)
          request = Request.new(
            entity: "User",
            id: id,
            json: json_params(query)
          )

          @result = parse(request.response).deep_symbolize_keys if success?
        end

        def self.query
          {
            "api.Contact.get" => Api::Contact.query
          }
        end

        private

        def parse(response)
          response = response["values"].first
          contact = response.delete("api.Contact.get")["values"].first

          {
            user: response,
            contact: contact
          }
        end
      end
    end
  end
end
