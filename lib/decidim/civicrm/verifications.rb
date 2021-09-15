# frozen_string_literal: true

require_relative "verifications/group_action_authorizer"

module Decidim
  module Civicrm
    # This namespace holds the logic to verify users with their CiViCRM data.
    module Verifications
      PROVIDER_NAME = "civicrm"
    end
  end
end
