# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      module Base
        class Request
          def initialize(verify_ssl: true)
            @verify_ssl = verify_ssl
          end

          attr_accessor :response

          def self.get(params, verify_ssl: true)
            instance = Request.new(verify_ssl: verify_ssl)
            response = instance.connection.get Decidim::Civicrm::Api.url do |request|
              request.params = instance.base_params.merge(params)

              # puts [request.path, URI.encode_www_form(request.params.sort)].join("/?") # DEBUG, to obtain the correct URL for stub_request
            end

            raise Decidim::Civicrm::Error, response.reason_phrase unless response.success?

            instance.response = JSON.parse(response.body).to_h
            instance
          end

          def self.post(params, verify_ssl: true)
            instance = Request.new(verify_ssl: verify_ssl)
            response = instance.connection.post Decidim::Civicrm::Api.url do |request|
              request.params = instance.base_params.merge(params)
            end

            raise Decidim::Civicrm::Error, response.reason_phrase unless response.success?

            instance.response = JSON.parse(response.body).to_h
            instance
          end

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
end
