# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      module Base
        class BaseQuery
          attr_reader :result, :request

          def success?
            return true if response.has_key?("values")

            raise Decidim::Civicrm::Error, "Malformed response for #{self.class.name}: #{response.to_json}"
          end

          def response
            @request.response
          end

          protected

          def json_params(params)
            params.merge(
              sequential: 1
            ).to_json
          end

          def parsed_response
            raise NotImplementedError
          end

          def default_query
            raise NotImplementedError
          end

          def store_result
            return unless success?

            @result = parsed_response
            @result = @result.deep_symbolize_keys if @result.is_a? Hash
          end
        end
      end
    end
  end
end
