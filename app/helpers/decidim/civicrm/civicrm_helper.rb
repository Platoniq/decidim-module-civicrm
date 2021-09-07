# frozen_string_literal: true

module Decidim
  module Civicrm
    module CivicrmHelper
      def civicrm_user?(user)
        user.identities.exists?(provider: Decidim::Civicrm::Verifications::PROVIDER_NAME)
      end
    end
  end
end
