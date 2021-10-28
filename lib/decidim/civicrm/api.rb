# frozen_string_literal: true

require_relative "api/base_query"
require_relative "api/contacts_in_group"
require_relative "api/find_contact"
require_relative "api/find_group"
require_relative "api/find_user"
require_relative "api/find_event"
require_relative "api/find_participant"
require_relative "api/participants_in_event"
require_relative "api/list_contact_groups"
require_relative "api/list_contact_memberships"
require_relative "api/list_groups"
require_relative "api/list_membership_types"
require_relative "api/request"

module Decidim
  module Civicrm
    # This namespace holds the logic to connect to the CiViCRM REST API.
    module Api
      def self.config
        Decidim::Civicrm.api
      end

      def self.credentials
        {
          api_key: config[:key],
          key: config[:secret]
        }
      end

      def self.url
        config[:url]
      end
    end
  end
end
