# frozen_string_literal: true

module Decidim
  module Civicrm
    module Api
      class ListContactsInGroup
        attr_reader :result

        def initialize(id, query = nil)
          @result = case Decidim::Civicrm::Api.version
                    when Decidim::Civicrm::Api.available_versions[:v3]
                      Decidim::Civicrm::Api::V3::ListContactsInGroup.new(id, query).result
                    when Decidim::Civicrm::Api.available_versions[:v4]
                      Decidim::Civicrm::Api::V4::ListContactsInGroup.new(id, query).result
                    end
        end
      end
    end
  end
end
