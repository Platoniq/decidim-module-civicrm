# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class Request
        def initialize(params, verify_ssl: true)
          @verify_ssl = verify_ssl

          response = connection.get Decidim::Civicrm::Api.url do |request|
            request.params = base_params.merge(params)
          end

          raise Decidim::Civicrm::Error, response.reason_phrase unless response.success?

          @response = JSON.parse(response.body).to_h
        end

        attr_reader :response

        private

        def connection
          @connection ||= Faraday.new(ssl: { verify: @verify_ssl })
        end

        def base_params
          Decidim::Civicrm::Api.credentials.merge(
            action: "Get"
          )
        end
      end
    end
  end
end
