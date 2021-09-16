# frozen_string_literal: true

require_relative "api/base/base_query"
require_relative "api/base/find_query"
require_relative "api/base/list_query"
require_relative "api/base/request"
require_relative "api/find_contact"
require_relative "api/find_group"
require_relative "api/find_user"
require_relative "api/list_contact_groups"
require_relative "api/list_contacts_in_group"
require_relative "api/list_contact_memberships"
require_relative "api/list_groups"
require_relative "api/list_membership_types"

module Decidim
  module Civicrm
    # This namespace holds the logic to connect to the CiViCRM REST API.
    module Api
      def self.config
        Rails.application.secrets[:civicrm][:api]
      end

      def self.credentials
        {
          api_key: config[:api_key],
          key: config[:key]
        }
      end

      def self.url
        config[:url]
      end
    end
  end
end
