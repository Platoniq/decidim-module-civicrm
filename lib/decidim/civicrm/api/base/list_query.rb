# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      module Base
        class ListQuery < BaseQuery
          protected

          def json_params(params)
            params.deep_merge(
              sequential: 1,
              options: { limit: 0 }
            ).to_json
          end

          def parsed_response
            response["values"].map { |item| parse_item(item) }
          end

          def parse_item(item)
            raise NotImplementedError
          end
        end
      end
    end
  end
end
