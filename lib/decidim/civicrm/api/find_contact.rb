# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class FindContact < BaseQuery
        def initialize(id)
          @request = Request.new(
            entity: "Contact",
            contact_id: id,
            json: json_params(query)
          )

          @result = parse(request.response).deep_symbolize_keys if success?
        end

        def self.query
          {
            "return" => "display_name"
          }
        end

        private

        def parse(response)
          response = response["values"].first

          {
            contact: contact
          }
        end
      end
    end
  end
end
