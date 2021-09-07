# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class BaseQuery
        attr_reader :result, :request

        protected

        def json_params(params)
          params.merge(
            sequential: 1
          ).to_json
        end

        def parse(response)
          raise NotImplementedError
        end

        def success?
          return true if response.has_key?("values")

          raise Decidim::Civicrm::Error, "Malformed response for #{self.class.name}: #{response.to_json}"
        end

        def response
          @request.response
        end
      end
    end
  end
end
